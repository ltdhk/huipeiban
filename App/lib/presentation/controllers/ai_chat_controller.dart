import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/ai_chat.dart';
import '../../data/repositories/ai_repository.dart';

part 'ai_chat_controller.g.dart';

/// AI 聊天控制器
@riverpod
class AiChatController extends _$AiChatController {
  late final AiRepository _repository;
  String? _currentSessionId; // 保存当前会话 ID
  Map<String, dynamic>? _latestCollectedInfo; // 保存最新收集的信息

  @override
  Future<List<AiChatMessage>> build() async {
    _repository = AiRepository();
    return [];
  }

  /// 获取最新收集的信息
  Map<String, dynamic>? get latestCollectedInfo => _latestCollectedInfo;

  /// 发送消息
  Future<void> sendMessage(String message) async {
    // 获取当前消息列表
    final currentMessages = state.value ?? [];

    // 添加用户消息
    final userMessage = AiChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: message,
      createdAt: DateTime.now(),
    );

    // 添加加载中的助手消息
    final loadingMessage = AiChatMessage(
      id: '${DateTime.now().millisecondsSinceEpoch + 1}',
      role: 'assistant',
      content: '',
      createdAt: DateTime.now(),
      isLoading: true,
    );

    // 更新 UI
    state = AsyncValue.data([...currentMessages, userMessage, loadingMessage]);

    try {
      // 发送请求，使用保存的 session_id（如果有的话）
      final response = await _repository.chat(
        message: message,
        sessionId: _currentSessionId,
      );

      // 保存 session_id 以便后续请求使用
      if (response.sessionId != null) {
        _currentSessionId = response.sessionId;
      }

      // 保存最新收集的信息
      if (response.collectedInfo != null && response.collectedInfo!.isNotEmpty) {
        _latestCollectedInfo = response.collectedInfo;
        debugPrint('AI响应收集到的信息: ${response.collectedInfo}');
      } else {
        debugPrint('AI响应未包含收集的信息');
      }

      // 移除加载消息，添加真实回复
      final assistantMessage = AiChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: response.message,
        createdAt: response.createdAt ?? DateTime.now(),
        recommendations: response.recommendations,
      );

      final updatedMessages = [...currentMessages, userMessage, assistantMessage];
      state = AsyncValue.data(updatedMessages);
    } catch (e) {
      // 移除加载消息，显示错误
      final errorMessage = AiChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: '抱歉，我遇到了一些问题。请稍后再试。',
        createdAt: DateTime.now(),
      );

      final updatedMessages = [...currentMessages, userMessage, errorMessage];
      state = AsyncValue.data(updatedMessages);

      rethrow;
    }
  }

  /// 清空聊天记录
  void clearMessages() {
    state = const AsyncValue.data([]);
    _currentSessionId = null; // 重置会话 ID
  }

  /// 加载历史记录
  Future<void> loadHistory({String? sessionId}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await _repository.getHistory(sessionId: sessionId);
    });
  }

  /// 添加订单卡片消息到聊天历史
  void addOrderCardMessage({
    required String orderNo,
    required double amount,
    required Map<String, dynamic> orderDetails,
  }) {
    final currentMessages = state.value ?? [];

    // 创建订单卡片消息（作为系统消息）
    final orderCardMessage = AiChatMessage(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      role: 'system', // 使用 system 角色标识订单卡片
      content: '订单创建成功',
      createdAt: DateTime.now(),
      orderCard: {
        'orderNo': orderNo,
        'amount': amount,
        'orderDetails': orderDetails,
      },
    );

    // 添加到消息列表
    state = AsyncValue.data([...currentMessages, orderCardMessage]);
    debugPrint('已添加订单卡片消息到聊天历史: $orderNo');
  }
}


/// AI 会话控制器
@riverpod
class AiSessionsController extends _$AiSessionsController {
  late final AiRepository _repository;

  @override
  Future<List<AiSession>> build() async {
    _repository = AiRepository();
    return await _loadSessions();
  }

  Future<List<AiSession>> _loadSessions() async {
    try {
      return await _repository.getSessions();
    } catch (e) {
      return [];
    }
  }

  /// 创建新会话
  Future<AiSession> createSession({String? title}) async {
    final session = await _repository.createSession(title: title);

    // 刷新会话列表
    state = await AsyncValue.guard(() => _loadSessions());

    return session;
  }

  /// 删除会话
  Future<void> deleteSession(int id) async {
    await _repository.deleteSession(id);

    // 刷新会话列表
    state = await AsyncValue.guard(() => _loadSessions());
  }

  /// 刷新会话列表
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadSessions());
  }
}
