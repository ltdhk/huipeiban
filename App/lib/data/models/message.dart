import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// 会话模型
///
/// 简化设计：只记录两个用户ID，不区分角色类型
@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required int id,
    @JsonKey(name: 'user1_id') required int user1Id,
    @JsonKey(name: 'user2_id') required int user2Id,
    @JsonKey(name: 'last_message') String? lastMessage,
    @JsonKey(name: 'last_message_at') DateTime? lastMessageAt,
    @JsonKey(name: 'user1_unread') @Default(0) int user1Unread,
    @JsonKey(name: 'user2_unread') @Default(0) int user2Unread,
    @Default('active') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // 当前用户的未读数（由后端根据当前用户计算）
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
    // 对方用户ID（由后端根据当前用户计算）
    @JsonKey(name: 'other_user_id') int? otherUserId,
    // 对方信息
    @JsonKey(name: 'other_party') OtherParty? otherParty,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

/// 对方用户信息
@freezed
class OtherParty with _$OtherParty {
  const factory OtherParty({
    required int id,
    @JsonKey(name: 'nickname') required String nickname,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'user_type') String? userType,
  }) = _OtherParty;

  factory OtherParty.fromJson(Map<String, dynamic> json) =>
      _$OtherPartyFromJson(json);
}

/// 消息模型
///
/// 简化设计：sender_id 和 receiver_id 都统一使用 users 表的 ID
@freezed
class Message with _$Message {
  const factory Message({
    required int id,
    @JsonKey(name: 'conversation_id') required int conversationId,
    @JsonKey(name: 'sender_id') required int senderId,
    @JsonKey(name: 'receiver_id') required int receiverId,
    @JsonKey(name: 'content_type') @Default('text') String contentType,
    required String content,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

/// 发送消息请求
@freezed
class SendMessageRequest with _$SendMessageRequest {
  const factory SendMessageRequest({
    @JsonKey(name: 'content_type') @Default('text') String contentType,
    required String content,
  }) = _SendMessageRequest;

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
}
