// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceImpl _$$ServiceImplFromJson(Map<String, dynamic> json) =>
    _$ServiceImpl(
      id: (json['id'] as num).toInt(),
      companionId: (json['companion_id'] as num).toInt(),
      title: json['title'] as String,
      category: json['category'] as String?,
      description: json['description'] as String?,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      basePrice: (json['base_price'] as num).toDouble(),
      additionalHourPrice: (json['additional_hour_price'] as num?)?.toDouble(),
      salesCount: (json['sales_count'] as num?)?.toInt() ?? 0,
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      specs: (json['specs'] as List<dynamic>?)
          ?.map((e) => ServiceSpec.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ServiceImplToJson(_$ServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companion_id': instance.companionId,
      'title': instance.title,
      'category': instance.category,
      'description': instance.description,
      'features': instance.features,
      'base_price': instance.basePrice,
      'additional_hour_price': instance.additionalHourPrice,
      'sales_count': instance.salesCount,
      'view_count': instance.viewCount,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'specs': instance.specs,
    };

_$ServiceSpecImpl _$$ServiceSpecImplFromJson(Map<String, dynamic> json) =>
    _$ServiceSpecImpl(
      id: (json['id'] as num).toInt(),
      serviceId: (json['service_id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      durationHours: (json['duration_hours'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ServiceSpecImplToJson(_$ServiceSpecImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'name': instance.name,
      'description': instance.description,
      'duration_hours': instance.durationHours,
      'price': instance.price,
      'features': instance.features,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
    };
