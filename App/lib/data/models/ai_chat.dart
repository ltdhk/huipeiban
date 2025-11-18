import 'package:freezed_annotation/freezed_annotation.dart';
import 'companion.dart';

part 'ai_chat.freezed.dart';
part 'ai_chat.g.dart';

/// AI 聊天请求
@freezed
class AiChatRequest with _$AiChatRequest {
  const factory AiChatRequest({
    required String message,
    @JsonKey(name: 'session_id') String? sessionId,
  }) = _AiChatRequest;

  factory AiChatRequest.fromJson(Map<String, dynamic> json) =>
      _$AiChatRequestFromJson(json);
}

/// AI 聊天响应
@freezed
class AiChatResponse with _$AiChatResponse {
  const factory AiChatResponse({
    required String message,
    @JsonKey(name: 'session_id') String? sessionId,
    String? intent,
    Map<String, dynamic>? entities,
    List<Companion>? recommendations,
    @JsonKey(name: 'collected_info') Map<String, dynamic>? collectedInfo,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AiChatResponse;

  factory AiChatResponse.fromJson(Map<String, dynamic> json) =>
      _$AiChatResponseFromJson(json);
}

/// AI 聊天消息 (本地使用)
@freezed
class AiChatMessage with _$AiChatMessage {
  const factory AiChatMessage({
    required String id,
    required String role, // user/assistant/system
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    List<Companion>? recommendations, // AI 推荐的陪诊师
    bool? isLoading, // 是否正在加载
    @JsonKey(name: 'order_card') Map<String, dynamic>? orderCard, // 订单卡片数据
  }) = _AiChatMessage;

  factory AiChatMessage.fromJson(Map<String, dynamic> json) =>
      _$AiChatMessageFromJson(json);
}

/// AI 会话
@freezed
class AiSession with _$AiSession {
  const factory AiSession({
    required String id,
    required String title,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AiSession;

  factory AiSession.fromJson(Map<String, dynamic> json) {
    // 处理 id 字段可能的类型问题
    final id = json['id'];
    final idStr = id is String ? id : id?.toString() ?? '';

    return AiSession(
      id: idStr,
      title: json['title'] as String? ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }
}
