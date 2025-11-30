// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: (json['id'] as num).toInt(),
      user1Id: (json['user1_id'] as num).toInt(),
      user2Id: (json['user2_id'] as num).toInt(),
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] == null
          ? null
          : DateTime.parse(json['last_message_at'] as String),
      user1Unread: (json['user1_unread'] as num?)?.toInt() ?? 0,
      user2Unread: (json['user2_unread'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'active',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      otherUserId: (json['other_user_id'] as num?)?.toInt(),
      otherParty: json['other_party'] == null
          ? null
          : OtherParty.fromJson(json['other_party'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user1_id': instance.user1Id,
      'user2_id': instance.user2Id,
      'last_message': instance.lastMessage,
      'last_message_at': instance.lastMessageAt?.toIso8601String(),
      'user1_unread': instance.user1Unread,
      'user2_unread': instance.user2Unread,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'unread_count': instance.unreadCount,
      'other_user_id': instance.otherUserId,
      'other_party': instance.otherParty,
    };

_$OtherPartyImpl _$$OtherPartyImplFromJson(Map<String, dynamic> json) =>
    _$OtherPartyImpl(
      id: (json['id'] as num).toInt(),
      nickname: json['nickname'] as String,
      avatarUrl: json['avatar_url'] as String?,
      userType: json['user_type'] as String?,
    );

Map<String, dynamic> _$$OtherPartyImplToJson(_$OtherPartyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'user_type': instance.userType,
    };

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversation_id'] as num).toInt(),
      senderId: (json['sender_id'] as num).toInt(),
      receiverId: (json['receiver_id'] as num).toInt(),
      contentType: json['content_type'] as String? ?? 'text',
      content: json['content'] as String,
      isRead: json['is_read'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_id': instance.senderId,
      'receiver_id': instance.receiverId,
      'content_type': instance.contentType,
      'content': instance.content,
      'is_read': instance.isRead,
      'is_deleted': instance.isDeleted,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$SendMessageRequestImpl _$$SendMessageRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SendMessageRequestImpl(
      contentType: json['content_type'] as String? ?? 'text',
      content: json['content'] as String,
    );

Map<String, dynamic> _$$SendMessageRequestImplToJson(
        _$SendMessageRequestImpl instance) =>
    <String, dynamic>{
      'content_type': instance.contentType,
      'content': instance.content,
    };
