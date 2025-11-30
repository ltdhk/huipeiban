import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import '../models/message.dart';

/// 消息与会话仓库（指向 IM 服务）
class MessageRepository {
  final Dio _dio = DioClient().createImDio();
  final Logger _logger = Logger();

  Future<PaginatedData<Conversation>> getConversations({int page = 1, int pageSize = 20}) async {
    try {
      final response = await _dio.get(
        ApiConstants.conversations,
        queryParameters: {'page': page, 'page_size': pageSize},
      );
      final apiResp = ApiResponse<PaginatedData<Conversation>>.fromJson(
        response.data,
        (json) => PaginatedData.fromJson(
          json as Map<String, dynamic>,
          (item) => Conversation.fromJson(item as Map<String, dynamic>),
        ),
      );
      if (apiResp.success && apiResp.data != null) {
        return apiResp.data!;
      }
      throw Exception(apiResp.message ?? '获取会话失败');
    } on DioException catch (e) {
      _logger.e('获取会话失败: ${e.message}');
      rethrow;
    }
  }

  Future<PaginatedData<Message>> getMessages(int conversationId, {int page = 1, int pageSize = 50}) async {
    try {
      final response = await _dio.get(
        ApiConstants.conversationDetail(conversationId),
        queryParameters: {'page': page, 'page_size': pageSize},
      );
      final apiResp = ApiResponse<PaginatedData<Message>>.fromJson(
        response.data,
        (json) => PaginatedData.fromJson(
          json as Map<String, dynamic>,
          (item) => Message.fromJson(item as Map<String, dynamic>),
        ),
      );
      if (apiResp.success && apiResp.data != null) {
        return apiResp.data!;
      }
      throw Exception(apiResp.message ?? '获取消息失败');
    } on DioException catch (e) {
      _logger.e('获取消息失败: ${e.message}');
      rethrow;
    }
  }

  Future<Message> sendMessage(int conversationId, {required String content, String contentType = 'text'}) async {
    try {
      final response = await _dio.post(ApiConstants.sendMessage(conversationId), data: {
        'content': content,
        'content_type': contentType,
      });
      final apiResp = ApiResponse<Message>.fromJson(
        response.data,
        (json) => Message.fromJson(json as Map<String, dynamic>),
      );
      if (apiResp.success && apiResp.data != null) return apiResp.data!;
      throw Exception(apiResp.message ?? '发送消息失败');
    } on DioException catch (e) {
      _logger.e('发送消息失败: ${e.message}');
      rethrow;
    }
  }

  Future<Conversation> createConversation({int? companionId, int? institutionId, String? title}) async {
    try {
      final response = await _dio.post(ApiConstants.conversations, data: {
        'companion_id': companionId,
        'institution_id': institutionId,
        'title': title,
      });
      final apiResp = ApiResponse<Conversation>.fromJson(
        response.data,
        (json) => Conversation.fromJson(json as Map<String, dynamic>),
      );
      if (apiResp.success && apiResp.data != null) return apiResp.data!;
      throw Exception(apiResp.message ?? '创建会话失败');
    } on DioException catch (e) {
      _logger.e('创建会话失败: ${e.message}');
      rethrow;
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get(ApiConstants.unreadCount);
      final apiResp = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      if (apiResp.success && apiResp.data != null) {
        return apiResp.data!['count'] as int? ?? 0;
      }
      throw Exception(apiResp.message ?? '获取未读失败');
    } on DioException catch (e) {
      _logger.e('获取未读失败: ${e.message}');
      rethrow;
    }
  }
}
