// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Patient _$PatientFromJson(Map<String, dynamic> json) {
  return _Patient.fromJson(json);
}

/// @nodoc
mixin _$Patient {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id', fromJson: _intFromJson)
  int get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  String? get birthDate => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_card')
  String? get idCard => throw _privateConstructorUsedError;
  String get relationship => throw _privateConstructorUsedError;
  @JsonKey(name: 'medical_history')
  String? get medicalHistory => throw _privateConstructorUsedError;
  String? get allergies => throw _privateConstructorUsedError;
  @JsonKey(name: 'special_needs')
  String? get specialNeeds => throw _privateConstructorUsedError;
  @JsonKey(name: 'insurance_type')
  String? get insuranceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'insurance_number')
  String? get insuranceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PatientCopyWith<Patient> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientCopyWith<$Res> {
  factory $PatientCopyWith(Patient value, $Res Function(Patient) then) =
      _$PatientCopyWithImpl<$Res, Patient>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'user_id', fromJson: _intFromJson) int userId,
      String name,
      String gender,
      @JsonKey(name: 'birth_date') String? birthDate,
      String? phone,
      @JsonKey(name: 'id_card') String? idCard,
      String relationship,
      @JsonKey(name: 'medical_history') String? medicalHistory,
      String? allergies,
      @JsonKey(name: 'special_needs') String? specialNeeds,
      @JsonKey(name: 'insurance_type') String? insuranceType,
      @JsonKey(name: 'insurance_number') String? insuranceNumber,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class _$PatientCopyWithImpl<$Res, $Val extends Patient>
    implements $PatientCopyWith<$Res> {
  _$PatientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? gender = null,
    Object? birthDate = freezed,
    Object? phone = freezed,
    Object? idCard = freezed,
    Object? relationship = null,
    Object? medicalHistory = freezed,
    Object? allergies = freezed,
    Object? specialNeeds = freezed,
    Object? insuranceType = freezed,
    Object? insuranceNumber = freezed,
    Object? isDefault = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      idCard: freezed == idCard
          ? _value.idCard
          : idCard // ignore: cast_nullable_to_non_nullable
              as String?,
      relationship: null == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String,
      medicalHistory: freezed == medicalHistory
          ? _value.medicalHistory
          : medicalHistory // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: freezed == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as String?,
      specialNeeds: freezed == specialNeeds
          ? _value.specialNeeds
          : specialNeeds // ignore: cast_nullable_to_non_nullable
              as String?,
      insuranceType: freezed == insuranceType
          ? _value.insuranceType
          : insuranceType // ignore: cast_nullable_to_non_nullable
              as String?,
      insuranceNumber: freezed == insuranceNumber
          ? _value.insuranceNumber
          : insuranceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PatientImplCopyWith<$Res> implements $PatientCopyWith<$Res> {
  factory _$$PatientImplCopyWith(
          _$PatientImpl value, $Res Function(_$PatientImpl) then) =
      __$$PatientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'user_id', fromJson: _intFromJson) int userId,
      String name,
      String gender,
      @JsonKey(name: 'birth_date') String? birthDate,
      String? phone,
      @JsonKey(name: 'id_card') String? idCard,
      String relationship,
      @JsonKey(name: 'medical_history') String? medicalHistory,
      String? allergies,
      @JsonKey(name: 'special_needs') String? specialNeeds,
      @JsonKey(name: 'insurance_type') String? insuranceType,
      @JsonKey(name: 'insurance_number') String? insuranceNumber,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class __$$PatientImplCopyWithImpl<$Res>
    extends _$PatientCopyWithImpl<$Res, _$PatientImpl>
    implements _$$PatientImplCopyWith<$Res> {
  __$$PatientImplCopyWithImpl(
      _$PatientImpl _value, $Res Function(_$PatientImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? gender = null,
    Object? birthDate = freezed,
    Object? phone = freezed,
    Object? idCard = freezed,
    Object? relationship = null,
    Object? medicalHistory = freezed,
    Object? allergies = freezed,
    Object? specialNeeds = freezed,
    Object? insuranceType = freezed,
    Object? insuranceNumber = freezed,
    Object? isDefault = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PatientImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      idCard: freezed == idCard
          ? _value.idCard
          : idCard // ignore: cast_nullable_to_non_nullable
              as String?,
      relationship: null == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String,
      medicalHistory: freezed == medicalHistory
          ? _value.medicalHistory
          : medicalHistory // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: freezed == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as String?,
      specialNeeds: freezed == specialNeeds
          ? _value.specialNeeds
          : specialNeeds // ignore: cast_nullable_to_non_nullable
              as String?,
      insuranceType: freezed == insuranceType
          ? _value.insuranceType
          : insuranceType // ignore: cast_nullable_to_non_nullable
              as String?,
      insuranceNumber: freezed == insuranceNumber
          ? _value.insuranceNumber
          : insuranceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientImpl implements _Patient {
  const _$PatientImpl(
      {@JsonKey(fromJson: _intFromJson) this.id = 0,
      @JsonKey(name: 'user_id', fromJson: _intFromJson) this.userId = 0,
      this.name = '',
      this.gender = '',
      @JsonKey(name: 'birth_date') this.birthDate,
      this.phone,
      @JsonKey(name: 'id_card') this.idCard,
      this.relationship = '',
      @JsonKey(name: 'medical_history') this.medicalHistory,
      this.allergies,
      @JsonKey(name: 'special_needs') this.specialNeeds,
      @JsonKey(name: 'insurance_type') this.insuranceType,
      @JsonKey(name: 'insurance_number') this.insuranceNumber,
      @JsonKey(name: 'is_default') this.isDefault = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$PatientImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'user_id', fromJson: _intFromJson)
  final int userId;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String gender;
  @override
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'id_card')
  final String? idCard;
  @override
  @JsonKey()
  final String relationship;
  @override
  @JsonKey(name: 'medical_history')
  final String? medicalHistory;
  @override
  final String? allergies;
  @override
  @JsonKey(name: 'special_needs')
  final String? specialNeeds;
  @override
  @JsonKey(name: 'insurance_type')
  final String? insuranceType;
  @override
  @JsonKey(name: 'insurance_number')
  final String? insuranceNumber;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'Patient(id: $id, userId: $userId, name: $name, gender: $gender, birthDate: $birthDate, phone: $phone, idCard: $idCard, relationship: $relationship, medicalHistory: $medicalHistory, allergies: $allergies, specialNeeds: $specialNeeds, insuranceType: $insuranceType, insuranceNumber: $insuranceNumber, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.idCard, idCard) || other.idCard == idCard) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.medicalHistory, medicalHistory) ||
                other.medicalHistory == medicalHistory) &&
            (identical(other.allergies, allergies) ||
                other.allergies == allergies) &&
            (identical(other.specialNeeds, specialNeeds) ||
                other.specialNeeds == specialNeeds) &&
            (identical(other.insuranceType, insuranceType) ||
                other.insuranceType == insuranceType) &&
            (identical(other.insuranceNumber, insuranceNumber) ||
                other.insuranceNumber == insuranceNumber) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      gender,
      birthDate,
      phone,
      idCard,
      relationship,
      medicalHistory,
      allergies,
      specialNeeds,
      insuranceType,
      insuranceNumber,
      isDefault,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      __$$PatientImplCopyWithImpl<_$PatientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientImplToJson(
      this,
    );
  }
}

abstract class _Patient implements Patient {
  const factory _Patient(
      {@JsonKey(fromJson: _intFromJson) final int id,
      @JsonKey(name: 'user_id', fromJson: _intFromJson) final int userId,
      final String name,
      final String gender,
      @JsonKey(name: 'birth_date') final String? birthDate,
      final String? phone,
      @JsonKey(name: 'id_card') final String? idCard,
      final String relationship,
      @JsonKey(name: 'medical_history') final String? medicalHistory,
      final String? allergies,
      @JsonKey(name: 'special_needs') final String? specialNeeds,
      @JsonKey(name: 'insurance_type') final String? insuranceType,
      @JsonKey(name: 'insurance_number') final String? insuranceNumber,
      @JsonKey(name: 'is_default') final bool isDefault,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt}) = _$PatientImpl;

  factory _Patient.fromJson(Map<String, dynamic> json) = _$PatientImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'user_id', fromJson: _intFromJson)
  int get userId;
  @override
  String get name;
  @override
  String get gender;
  @override
  @JsonKey(name: 'birth_date')
  String? get birthDate;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'id_card')
  String? get idCard;
  @override
  String get relationship;
  @override
  @JsonKey(name: 'medical_history')
  String? get medicalHistory;
  @override
  String? get allergies;
  @override
  @JsonKey(name: 'special_needs')
  String? get specialNeeds;
  @override
  @JsonKey(name: 'insurance_type')
  String? get insuranceType;
  @override
  @JsonKey(name: 'insurance_number')
  String? get insuranceNumber;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePatientRequest _$CreatePatientRequestFromJson(Map<String, dynamic> json) {
  return _CreatePatientRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePatientRequest {
  String get name => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get relationship => throw _privateConstructorUsedError;
  @JsonKey(name: 'medical_history')
  String? get medicalHistory => throw _privateConstructorUsedError;
  String? get allergies => throw _privateConstructorUsedError;
  @JsonKey(name: 'special_needs')
  String? get specialNeeds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreatePatientRequestCopyWith<CreatePatientRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePatientRequestCopyWith<$Res> {
  factory $CreatePatientRequestCopyWith(CreatePatientRequest value,
          $Res Function(CreatePatientRequest) then) =
      _$CreatePatientRequestCopyWithImpl<$Res, CreatePatientRequest>;
  @useResult
  $Res call(
      {String name,
      String gender,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      String? phone,
      String relationship,
      @JsonKey(name: 'medical_history') String? medicalHistory,
      String? allergies,
      @JsonKey(name: 'special_needs') String? specialNeeds});
}

/// @nodoc
class _$CreatePatientRequestCopyWithImpl<$Res,
        $Val extends CreatePatientRequest>
    implements $CreatePatientRequestCopyWith<$Res> {
  _$CreatePatientRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? gender = null,
    Object? birthDate = freezed,
    Object? phone = freezed,
    Object? relationship = null,
    Object? medicalHistory = freezed,
    Object? allergies = freezed,
    Object? specialNeeds = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      relationship: null == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String,
      medicalHistory: freezed == medicalHistory
          ? _value.medicalHistory
          : medicalHistory // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: freezed == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as String?,
      specialNeeds: freezed == specialNeeds
          ? _value.specialNeeds
          : specialNeeds // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePatientRequestImplCopyWith<$Res>
    implements $CreatePatientRequestCopyWith<$Res> {
  factory _$$CreatePatientRequestImplCopyWith(_$CreatePatientRequestImpl value,
          $Res Function(_$CreatePatientRequestImpl) then) =
      __$$CreatePatientRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String gender,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      String? phone,
      String relationship,
      @JsonKey(name: 'medical_history') String? medicalHistory,
      String? allergies,
      @JsonKey(name: 'special_needs') String? specialNeeds});
}

/// @nodoc
class __$$CreatePatientRequestImplCopyWithImpl<$Res>
    extends _$CreatePatientRequestCopyWithImpl<$Res, _$CreatePatientRequestImpl>
    implements _$$CreatePatientRequestImplCopyWith<$Res> {
  __$$CreatePatientRequestImplCopyWithImpl(_$CreatePatientRequestImpl _value,
      $Res Function(_$CreatePatientRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? gender = null,
    Object? birthDate = freezed,
    Object? phone = freezed,
    Object? relationship = null,
    Object? medicalHistory = freezed,
    Object? allergies = freezed,
    Object? specialNeeds = freezed,
  }) {
    return _then(_$CreatePatientRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      relationship: null == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String,
      medicalHistory: freezed == medicalHistory
          ? _value.medicalHistory
          : medicalHistory // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: freezed == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as String?,
      specialNeeds: freezed == specialNeeds
          ? _value.specialNeeds
          : specialNeeds // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePatientRequestImpl implements _CreatePatientRequest {
  const _$CreatePatientRequestImpl(
      {required this.name,
      required this.gender,
      @JsonKey(name: 'birth_date') this.birthDate,
      this.phone,
      required this.relationship,
      @JsonKey(name: 'medical_history') this.medicalHistory,
      this.allergies,
      @JsonKey(name: 'special_needs') this.specialNeeds});

  factory _$CreatePatientRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePatientRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String gender;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  @override
  final String? phone;
  @override
  final String relationship;
  @override
  @JsonKey(name: 'medical_history')
  final String? medicalHistory;
  @override
  final String? allergies;
  @override
  @JsonKey(name: 'special_needs')
  final String? specialNeeds;

  @override
  String toString() {
    return 'CreatePatientRequest(name: $name, gender: $gender, birthDate: $birthDate, phone: $phone, relationship: $relationship, medicalHistory: $medicalHistory, allergies: $allergies, specialNeeds: $specialNeeds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePatientRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.medicalHistory, medicalHistory) ||
                other.medicalHistory == medicalHistory) &&
            (identical(other.allergies, allergies) ||
                other.allergies == allergies) &&
            (identical(other.specialNeeds, specialNeeds) ||
                other.specialNeeds == specialNeeds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, gender, birthDate, phone,
      relationship, medicalHistory, allergies, specialNeeds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePatientRequestImplCopyWith<_$CreatePatientRequestImpl>
      get copyWith =>
          __$$CreatePatientRequestImplCopyWithImpl<_$CreatePatientRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePatientRequestImplToJson(
      this,
    );
  }
}

abstract class _CreatePatientRequest implements CreatePatientRequest {
  const factory _CreatePatientRequest(
          {required final String name,
          required final String gender,
          @JsonKey(name: 'birth_date') final DateTime? birthDate,
          final String? phone,
          required final String relationship,
          @JsonKey(name: 'medical_history') final String? medicalHistory,
          final String? allergies,
          @JsonKey(name: 'special_needs') final String? specialNeeds}) =
      _$CreatePatientRequestImpl;

  factory _CreatePatientRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePatientRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get gender;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate;
  @override
  String? get phone;
  @override
  String get relationship;
  @override
  @JsonKey(name: 'medical_history')
  String? get medicalHistory;
  @override
  String? get allergies;
  @override
  @JsonKey(name: 'special_needs')
  String? get specialNeeds;
  @override
  @JsonKey(ignore: true)
  _$$CreatePatientRequestImplCopyWith<_$CreatePatientRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
