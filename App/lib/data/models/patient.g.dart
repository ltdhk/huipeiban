// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientImpl _$$PatientImplFromJson(Map<String, dynamic> json) =>
    _$PatientImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      name: json['name'] as String,
      gender: json['gender'] as String,
      birthDate: json['birth_date'] as String?,
      phone: json['phone'] as String?,
      idCard: json['id_card'] as String?,
      relationship: json['relationship'] as String,
      medicalHistory: json['medical_history'] as String?,
      allergies: json['allergies'] as String?,
      specialNeeds: json['special_needs'] as String?,
      insuranceType: json['insurance_type'] as String?,
      insuranceNumber: json['insurance_number'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$PatientImplToJson(_$PatientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'gender': instance.gender,
      'birth_date': instance.birthDate,
      'phone': instance.phone,
      'id_card': instance.idCard,
      'relationship': instance.relationship,
      'medical_history': instance.medicalHistory,
      'allergies': instance.allergies,
      'special_needs': instance.specialNeeds,
      'insurance_type': instance.insuranceType,
      'insurance_number': instance.insuranceNumber,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$CreatePatientRequestImpl _$$CreatePatientRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePatientRequestImpl(
      name: json['name'] as String,
      gender: json['gender'] as String,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      phone: json['phone'] as String?,
      relationship: json['relationship'] as String,
      medicalHistory: json['medical_history'] as String?,
      allergies: json['allergies'] as String?,
      specialNeeds: json['special_needs'] as String?,
    );

Map<String, dynamic> _$$CreatePatientRequestImplToJson(
        _$CreatePatientRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'gender': instance.gender,
      'birth_date': instance.birthDate?.toIso8601String(),
      'phone': instance.phone,
      'relationship': instance.relationship,
      'medical_history': instance.medicalHistory,
      'allergies': instance.allergies,
      'special_needs': instance.specialNeeds,
    };
