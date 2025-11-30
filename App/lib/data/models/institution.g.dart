// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstitutionImpl _$$InstitutionImplFromJson(Map<String, dynamic> json) =>
    _$InstitutionImpl(
      id: json['id'] == null ? 0 : _intFromJson(json['id']),
      userId: (json['user_id'] as num?)?.toInt(),
      name: json['name'] as String? ?? '',
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      businessLicense: json['business_license'] as String?,
      rating: json['rating'] == null ? 5.0 : _doubleFromJson(json['rating']),
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      totalOrders: (json['total_orders'] as num?)?.toInt() ?? 0,
      completedOrders: (json['completed_orders'] as num?)?.toInt() ?? 0,
      companionCount: (json['companion_count'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'approved',
      isVerified: json['is_verified'] as bool? ?? false,
      serviceHospitals: (json['service_hospitals'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      serviceArea: (json['service_area'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$InstitutionImplToJson(_$InstitutionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'logo_url': instance.logoUrl,
      'description': instance.description,
      'address': instance.address,
      'phone': instance.phone,
      'city': instance.city,
      'business_license': instance.businessLicense,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'total_orders': instance.totalOrders,
      'completed_orders': instance.completedOrders,
      'companion_count': instance.companionCount,
      'status': instance.status,
      'is_verified': instance.isVerified,
      'service_hospitals': instance.serviceHospitals,
      'service_area': instance.serviceArea,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$InstitutionRecommendationImpl _$$InstitutionRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$InstitutionRecommendationImpl(
      institution:
          Institution.fromJson(json['institution'] as Map<String, dynamic>),
      matchScore: (json['match_score'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$InstitutionRecommendationImplToJson(
        _$InstitutionRecommendationImpl instance) =>
    <String, dynamic>{
      'institution': instance.institution,
      'match_score': instance.matchScore,
      'reason': instance.reason,
    };
