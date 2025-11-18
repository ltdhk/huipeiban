import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/ai_chat.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';

part 'ai_api_provider.g.dart';

/// AI API Provider
@RestApi(baseUrl: ApiConstants.apiBasePath)
abstract class AiApiProvider {
  factory AiApiProvider(Dio dio, {String baseUrl}) = _AiApiProvider;

  /// AI 聊天
  @POST(ApiConstants.aiChat)
  Future<ApiResponse<AiChatResponse>> chat(
    @Body() Map<String, dynamic> data,
  );

  /// 获取聊天历史
  @GET(ApiConstants.aiHistory)
  Future<ApiResponse<List<AiChatMessage>>> getHistory(
    @Query('session_id') String? sessionId,
    @Query('limit') int? limit,
  );

  /// 获取会话列表
  @GET(ApiConstants.aiSessions)
  Future<ApiResponse<List<AiSession>>> getSessions();

  /// 创建新会话
  @POST(ApiConstants.aiSessions)
  Future<ApiResponse<AiSession>> createSession(
    @Body() Map<String, dynamic> data,
  );

  /// 删除会话
  @DELETE('${ApiConstants.aiSessions}/{id}')
  Future<HttpResponse<void>> deleteSession(
    @Path('id') int id,
  );
}
