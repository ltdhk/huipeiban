// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressImpl _$$AddressImplFromJson(Map<String, dynamic> json) =>
    _$AddressImpl(
      id: json['id'] == null ? 0 : _intFromJson(json['id']),
      userId: json['user_id'] == null ? 0 : _intFromJson(json['user_id']),
      contactName: json['contact_name'] as String? ?? '',
      contactPhone: json['contact_phone'] as String? ?? '',
      province: json['province'] as String? ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      detailAddress: json['detail_address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      addressType: json['address_type'] as String? ?? 'other',
      label: json['label'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AddressImplToJson(_$AddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'contact_name': instance.contactName,
      'contact_phone': instance.contactPhone,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'detail_address': instance.detailAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address_type': instance.addressType,
      'label': instance.label,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$CreateAddressRequestImpl _$$CreateAddressRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateAddressRequestImpl(
      contactName: json['contact_name'] as String,
      contactPhone: json['contact_phone'] as String,
      province: json['province'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      detailAddress: json['detail_address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      addressType: json['address_type'] as String?,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$$CreateAddressRequestImplToJson(
        _$CreateAddressRequestImpl instance) =>
    <String, dynamic>{
      'contact_name': instance.contactName,
      'contact_phone': instance.contactPhone,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'detail_address': instance.detailAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address_type': instance.addressType,
      'label': instance.label,
    };
