// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanionImpl _$$CompanionImplFromJson(Map<String, dynamic> json) =>
    _$CompanionImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
      institutionId: (json['institution_id'] as num?)?.toInt(),
      serviceYears: (json['service_years'] as num?)?.toInt(),
      introduction: json['introduction'] as String?,
      hasCar: json['has_car'] as bool? ?? false,
      carType: json['car_type'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      totalOrders: (json['total_orders'] as num?)?.toInt() ?? 0,
      completedOrders: (json['completed_orders'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'approved',
      isVerified: json['is_verified'] as bool? ?? false,
      isOnline: json['is_online'] as bool? ?? false,
      serviceHospitals: (json['service_hospitals'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      serviceArea: (json['service_area'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      specialties: (json['specialties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$CompanionImplToJson(_$CompanionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'gender': instance.gender,
      'age': instance.age,
      'institution_id': instance.institutionId,
      'service_years': instance.serviceYears,
      'introduction': instance.introduction,
      'has_car': instance.hasCar,
      'car_type': instance.carType,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'total_orders': instance.totalOrders,
      'completed_orders': instance.completedOrders,
      'status': instance.status,
      'is_verified': instance.isVerified,
      'is_online': instance.isOnline,
      'service_hospitals': instance.serviceHospitals,
      'service_area': instance.serviceArea,
      'specialties': instance.specialties,
      'certificates': instance.certificates,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$CompanionRecommendationImpl _$$CompanionRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$CompanionRecommendationImpl(
      companion: Companion.fromJson(json['companion'] as Map<String, dynamic>),
      matchScore: (json['match_score'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$CompanionRecommendationImplToJson(
        _$CompanionRecommendationImpl instance) =>
    <String, dynamic>{
      'companion': instance.companion,
      'match_score': instance.matchScore,
      'reason': instance.reason,
    };
