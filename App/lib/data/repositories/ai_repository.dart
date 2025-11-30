import 'package:dio/dio.dart';
import '../models/ai_chat.dart';
import '../providers/ai_api_provider.dart';
import '../../core/network/dio_client.dart';

/// AI Repository
class AiRepository {
  late final AiApiProvider _apiProvider;
  late final Dio _dio;

  AiRepository() {
    _dio = DioClient().dio;
    _apiProvider = AiApiProvider(_dio);
  }

  /// 发送聊天消息
  /// AI 聊天需要更长的超时时间(120秒)
  Future<AiChatResponse> chat({
    required String message,
    String? sessionId,
  }) async {
    // 临时修改请求的超时时间
    final originalReceiveTimeout = _dio.options.receiveTimeout;
    _dio.options.receiveTimeout = const Duration(seconds: 120);

    try {
      final response = await _apiProvider.chat({
        'message': message,
        if (sessionId != null) 'session_id': sessionId,
      });

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.message ?? 'AI 聊天失败');
      }
    } finally {
      // 恢复原始超时时间
      _dio.options.receiveTimeout = originalReceiveTimeout;
    }
  }

  /// 获取聊天历史
  Future<List<AiChatMessage>> getHistory({
    String? sessionId,
    int limit = 50,
  }) async {
    final response = await _apiProvider.getHistory(sessionId, limit);

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? '获取历史记录失败');
    }
  }

  /// 获取会话列表
  Future<List<AiSession>> getSessions() async {
    final response = await _apiProvider.getSessions();

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? '获取会话列表失败');
    }
  }

  /// 创建新会话
  Future<AiSession> createSession({String? title}) async {
    final response = await _apiProvider.createSession({
      if (title != null) 'title': title,
    });

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? '创建会话失败');
    }
  }

  /// 删除会话
  Future<void> deleteSession(int id) async {
    await _apiProvider.deleteSession(id);
  }
}
