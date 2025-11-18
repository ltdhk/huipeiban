import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// 会话模型
@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'companion_id') int? companionId,
    @JsonKey(name: 'institution_id') int? institutionId,
    String? title,
    @JsonKey(name: 'last_message') String? lastMessage,
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
    @Default('active') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // 对方信息
    @JsonKey(name: 'other_party') OtherParty? otherParty,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

/// 对方信息
@freezed
class OtherParty with _$OtherParty {
  const factory OtherParty({
    required int id,
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    required String type, // companion/institution
  }) = _OtherParty;

  factory OtherParty.fromJson(Map<String, dynamic> json) =>
      _$OtherPartyFromJson(json);
}

/// 消息模型
@freezed
class Message with _$Message {
  const factory Message({
    required int id,
    @JsonKey(name: 'conversation_id') required int conversationId,
    @JsonKey(name: 'sender_id') required int senderId,
    @JsonKey(name: 'sender_type') required String senderType,
    @JsonKey(name: 'receiver_id') required int receiverId,
    @JsonKey(name: 'receiver_type') required String receiverType,
    @JsonKey(name: 'content_type') @Default('text') String contentType,
    required String content,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

/// 发送消息请求
@freezed
class SendMessageRequest with _$SendMessageRequest {
  const factory SendMessageRequest({
    @JsonKey(name: 'receiver_id') required int receiverId,
    @JsonKey(name: 'receiver_type') required String receiverType,
    @JsonKey(name: 'content_type') @Default('text') String contentType,
    required String content,
  }) = _SendMessageRequest;

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
}
