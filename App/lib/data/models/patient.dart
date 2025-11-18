import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient.freezed.dart';
part 'patient.g.dart';

/// 就诊人模型
@freezed
class Patient with _$Patient {
  const factory Patient({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String name,
    required String gender,
    @JsonKey(name: 'birth_date') String? birthDate,
    String? phone,
    @JsonKey(name: 'id_card') String? idCard,
    required String relationship,
    @JsonKey(name: 'medical_history') String? medicalHistory,
    String? allergies,
    @JsonKey(name: 'special_needs') String? specialNeeds,
    @JsonKey(name: 'insurance_type') String? insuranceType,
    @JsonKey(name: 'insurance_number') String? insuranceNumber,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _Patient;

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
}

/// 创建就诊人请求
@freezed
class CreatePatientRequest with _$CreatePatientRequest {
  const factory CreatePatientRequest({
    required String name,
    required String gender,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    String? phone,
    required String relationship,
    @JsonKey(name: 'medical_history') String? medicalHistory,
    String? allergies,
    @JsonKey(name: 'special_needs') String? specialNeeds,
  }) = _CreatePatientRequest;

  factory CreatePatientRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePatientRequestFromJson(json);
}
