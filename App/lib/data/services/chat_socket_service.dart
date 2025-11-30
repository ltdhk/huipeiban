import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/io.dart';
import '../../core/constants/api_constants.dart';

/// WebSocket 服务，负责与 IM 服务端通信
class ChatSocketService {
  final Logger _logger = Logger();
  final _incomingController = StreamController<Map<String, dynamic>>.broadcast();
  IOWebSocketChannel? _channel;
  Timer? _reconnectTimer;
  String? _token;
  bool _authOk = false;

  Stream<Map<String, dynamic>> get stream => _incomingController.stream;

  Future<void> ensureConnected(String token) async {
    if (_token == token && _channel != null) return;
    await connect(token);
  }

  Future<void> connect(String token) async {
    _reconnectTimer?.cancel();
    await _channel?.sink.close();
    _token = token;
    await _open();
  }

  Future<void> _open() async {
    if (_token == null) return;
    try {
      _logger.i('连接 IM WebSocket: ${ApiConstants.imWsUrl}');
      _channel = IOWebSocketChannel.connect(Uri.parse(ApiConstants.imWsUrl));
      _channel!.stream.listen(_handleMessage, onDone: _handleDone, onError: (e) => _handleError(e));
      _authOk = false;
      _channel!.sink.add(jsonEncode({'type': 'auth', 'token': _token}));
    } catch (e) {
      _logger.e('连接 IM 失败: $e');
      _scheduleReconnect();
    }
  }

  void sendChat({
    required int conversationId,
    required String content,
    required String tempId,
    String contentType = 'text',
  }) {
    _channel?.sink.add(jsonEncode({
      'type': 'send',
      'data': {
        'tempId': tempId,
        'convId': conversationId,
        'content': content,
        'contentType': contentType,
      }
    }));
  }

  void markRead(int convId, List<int> messageIds) {
    _channel?.sink.add(jsonEncode({'type': 'read', 'convId': convId, 'messageIds': messageIds}));
  }

  void _handleMessage(dynamic raw) {
    try {
      final data = jsonDecode(raw as String) as Map<String, dynamic>;
      _logger.d('收到 IM 消息: ${data['type']}');
      if (data['type'] == 'auth_ok') {
        _authOk = true;
        _logger.i('IM 认证成功: ${data['userId']}');
      } else if (data['type'] == 'message') {
        _logger.i('收到新消息: ${data['data']}');
      } else if (data['type'] == 'ack') {
        _logger.i('消息发送确认: ${data['tempId']}');
      }
      _incomingController.add(data);
    } catch (e) {
      _logger.e('解析 IM 消息失败: $e');
    }
  }

  void _handleDone() {
    _logger.w('IM WebSocket 断开');
    _authOk = false;
    _scheduleReconnect();
  }

  void _handleError(Object error) {
    _logger.e('IM WebSocket 错误: $error');
    _authOk = false;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () => _open());
  }

  Future<void> dispose() async {
    _reconnectTimer?.cancel();
    await _incomingController.close();
    await _channel?.sink.close();
  }
}
