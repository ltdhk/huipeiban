// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      companionId: (json['companion_id'] as num?)?.toInt(),
      institutionId: (json['institution_id'] as num?)?.toInt(),
      title: json['title'] as String?,
      lastMessage: json['last_message'] as String?,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'active',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      otherParty: json['other_party'] == null
          ? null
          : OtherParty.fromJson(json['other_party'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'companion_id': instance.companionId,
      'institution_id': instance.institutionId,
      'title': instance.title,
      'last_message': instance.lastMessage,
      'unread_count': instance.unreadCount,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'other_party': instance.otherParty,
    };

_$OtherPartyImpl _$$OtherPartyImplFromJson(Map<String, dynamic> json) =>
    _$OtherPartyImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$OtherPartyImplToJson(_$OtherPartyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'type': instance.type,
    };

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversation_id'] as num).toInt(),
      senderId: (json['sender_id'] as num).toInt(),
      senderType: json['sender_type'] as String,
      receiverId: (json['receiver_id'] as num).toInt(),
      receiverType: json['receiver_type'] as String,
      contentType: json['content_type'] as String? ?? 'text',
      content: json['content'] as String,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_id': instance.senderId,
      'sender_type': instance.senderType,
      'receiver_id': instance.receiverId,
      'receiver_type': instance.receiverType,
      'content_type': instance.contentType,
      'content': instance.content,
      'is_read': instance.isRead,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$SendMessageRequestImpl _$$SendMessageRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SendMessageRequestImpl(
      receiverId: (json['receiver_id'] as num).toInt(),
      receiverType: json['receiver_type'] as String,
      contentType: json['content_type'] as String? ?? 'text',
      content: json['content'] as String,
    );

Map<String, dynamic> _$$SendMessageRequestImplToJson(
        _$SendMessageRequestImpl instance) =>
    <String, dynamic>{
      'receiver_id': instance.receiverId,
      'receiver_type': instance.receiverType,
      'content_type': instance.contentType,
      'content': instance.content,
    };
