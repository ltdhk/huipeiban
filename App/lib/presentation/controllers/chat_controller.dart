import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/services/storage_service.dart';
import '../../data/models/message.dart';
import '../../data/repositories/message_repository.dart';
import '../../data/services/chat_socket_service.dart';

final chatSocketServiceProvider = Provider<ChatSocketService>((ref) {
  final service = ChatSocketService();
  ref.onDispose(service.dispose);
  return service;
});

final chatListProvider =
    StateNotifierProvider<ChatListNotifier, AsyncValue<List<Conversation>>>((ref) {
  final repo = MessageRepository();
  final socket = ref.watch(chatSocketServiceProvider);
  return ChatListNotifier(repo, socket);
});

class ChatListNotifier extends StateNotifier<AsyncValue<List<Conversation>>> {
  final MessageRepository _repo;
  final ChatSocketService _socket;
  final StorageService _storage = StorageService();
  StreamSubscription<Map<String, dynamic>>? _sub;

  ChatListNotifier(this._repo, this._socket) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    await _connectSocket();
    await load();
    _sub = _socket.stream.listen(_handleSocketEvent);
  }

  Future<void> _connectSocket() async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      await _socket.ensureConnected(token);
    }
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final res = await _repo.getConversations();
      return res.list;
    });
  }

  void _handleSocketEvent(Map<String, dynamic> event) {
    final type = event['type'];
    if (type != 'message' && type != 'ack') return;
    final payload = (type == 'message' ? event['data'] : event['message']) as Map<String, dynamic>?;
    if (payload == null) return;
    final msg = Message.fromJson(payload);
    _applyIncoming(msg, isAck: type == 'ack');
  }

  void _applyIncoming(Message msg, {bool isAck = false}) {
    final userId = _storage.getUserId();
    final list = state.value ?? [];
    final idx = list.indexWhere((c) => c.id == msg.conversationId);
    final updatedList = [...list];
    if (idx >= 0) {
      final conv = updatedList[idx];
      final isIncoming = userId != null && msg.receiverId == userId;
      updatedList[idx] = conv.copyWith(
        lastMessage: msg.content,
        unreadCount: isIncoming ? conv.unreadCount + 1 : conv.unreadCount,
        updatedAt: msg.createdAt ?? DateTime.now(),
      );
    } else {
      // 新会话 - 简化设计，只记录双方用户ID
      final otherUserId = msg.senderId == userId ? msg.receiverId : msg.senderId;
      updatedList.insert(
        0,
        Conversation(
          id: msg.conversationId,
          user1Id: userId ?? msg.senderId,
          user2Id: otherUserId,
          lastMessage: msg.content,
          lastMessageAt: msg.createdAt ?? DateTime.now(),
          unreadCount: userId != null && msg.receiverId == userId ? 1 : 0,
          otherUserId: otherUserId,
          status: 'active',
          createdAt: msg.createdAt ?? DateTime.now(),
          updatedAt: msg.createdAt ?? DateTime.now(),
          otherParty: null,
        ),
      );
    }
    state = AsyncValue.data(updatedList);
  }

  Future<void> refresh() => load();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final chatMessagesProvider = StateNotifierProvider.autoDispose
    .family<ChatMessagesNotifier, AsyncValue<List<Message>>, int>((ref, conversationId) {
  final repo = MessageRepository();
  final socket = ref.watch(chatSocketServiceProvider);
  return ChatMessagesNotifier(repo, socket, conversationId);
});

class ChatMessagesNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  final MessageRepository _repo;
  final ChatSocketService _socket;
  final StorageService _storage = StorageService();
  final int conversationId;
  StreamSubscription<Map<String, dynamic>>? _sub;
  final Map<String, int> _pendingTempToLocalId = {};

  ChatMessagesNotifier(this._repo, this._socket, this.conversationId)
      : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    await _connectSocket();
    await load();
    _sub = _socket.stream.listen(_handleSocketEvent);
  }

  Future<void> _connectSocket() async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      await _socket.ensureConnected(token);
    }
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final res = await _repo.getMessages(conversationId);
      return res.list;
    });
  }

  void _handleSocketEvent(Map<String, dynamic> event) {
    final type = event['type'];
    if (type != 'message' && type != 'ack') return;
    final payload = (type == 'message' ? event['data'] : event['message']) as Map<String, dynamic>?;
    if (payload == null) return;
    final msg = Message.fromJson(payload);
    if (msg.conversationId != conversationId) return;

    if (type == 'ack' && event['tempId'] is String) {
      _replacePending(event['tempId'] as String, msg);
    } else {
      _appendMessage(msg);
    }
    _autoReadIfNeeded(msg);
  }

  void _appendMessage(Message msg) {
    final current = state.value ?? [];
    if (current.any((m) => m.id == msg.id)) return;
    state = AsyncValue.data([...current, msg]);
  }

  void _replacePending(String tempId, Message serverMsg) {
    final placeholderId = _pendingTempToLocalId[tempId];
    final current = state.value ?? [];
    final updated = [...current];
    final idx = placeholderId != null ? updated.indexWhere((m) => m.id == placeholderId) : -1;
    if (idx >= 0) {
      updated[idx] = serverMsg;
    } else {
      updated.add(serverMsg);
    }
    state = AsyncValue.data(updated);
    _pendingTempToLocalId.remove(tempId);
  }

  Future<void> sendMessage(String content, {String contentType = 'text'}) async {
    final userId = _storage.getUserId();
    if (userId == null) throw Exception('未登录');
    final tempId = const Uuid().v4();
    final placeholderId = DateTime.now().millisecondsSinceEpoch;
    _pendingTempToLocalId[tempId] = placeholderId;

    final temp = Message(
      id: placeholderId,
      conversationId: conversationId,
      senderId: userId,
      receiverId: 0,  // 实际接收者ID由服务器确定
      contentType: contentType,
      content: content,
      isRead: true,
      createdAt: DateTime.now(),
    );
    final current = state.value ?? [];
    state = AsyncValue.data([...current, temp]);

    _socket.sendChat(
      conversationId: conversationId,
      content: content,
      tempId: tempId,
      contentType: contentType,
    );
  }

  void _autoReadIfNeeded(Message msg) {
    final userId = _storage.getUserId();
    if (userId != null && msg.receiverId == userId) {
      _socket.markRead(conversationId, [msg.id]);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
