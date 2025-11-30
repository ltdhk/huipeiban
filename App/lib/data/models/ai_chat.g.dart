// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiChatRequestImpl _$$AiChatRequestImplFromJson(Map<String, dynamic> json) =>
    _$AiChatRequestImpl(
      message: json['message'] as String,
      sessionId: json['session_id'] as String?,
    );

Map<String, dynamic> _$$AiChatRequestImplToJson(_$AiChatRequestImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'session_id': instance.sessionId,
    };

_$AiChatResponseImpl _$$AiChatResponseImplFromJson(Map<String, dynamic> json) =>
    _$AiChatResponseImpl(
      message: json['message'] as String,
      sessionId: json['session_id'] as String?,
      intent: json['intent'] as String?,
      entities: json['entities'] as Map<String, dynamic>?,
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((e) => Companion.fromJson(e as Map<String, dynamic>))
          .toList(),
      institutionRecommendations:
          (json['institution_recommendations'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList(),
      collectedInfo: json['collected_info'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$AiChatResponseImplToJson(
        _$AiChatResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'session_id': instance.sessionId,
      'intent': instance.intent,
      'entities': instance.entities,
      'recommendations': instance.recommendations,
      'institution_recommendations': instance.institutionRecommendations,
      'collected_info': instance.collectedInfo,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$AiChatMessageImpl _$$AiChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$AiChatMessageImpl(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((e) => Companion.fromJson(e as Map<String, dynamic>))
          .toList(),
      institutionRecommendations:
          (json['institution_recommendations'] as List<dynamic>?)
              ?.map((e) => Institution.fromJson(e as Map<String, dynamic>))
              .toList(),
      isLoading: json['isLoading'] as bool?,
      orderCard: json['order_card'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AiChatMessageImplToJson(_$AiChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'recommendations': instance.recommendations,
      'institution_recommendations': instance.institutionRecommendations,
      'isLoading': instance.isLoading,
      'order_card': instance.orderCard,
    };
