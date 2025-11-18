// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'companion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Companion _$CompanionFromJson(Map<String, dynamic> json) {
  return _Companion.fromJson(json);
}

/// @nodoc
mixin _$Companion {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  @JsonKey(name: 'institution_id')
  int? get institutionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_years')
  int? get serviceYears => throw _privateConstructorUsedError;
  String? get introduction => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_car')
  bool get hasCar => throw _privateConstructorUsedError;
  @JsonKey(name: 'car_type')
  String? get carType => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_count')
  int get reviewCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_orders')
  int get totalOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_orders')
  int get completedOrders => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_online')
  bool get isOnline => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_hospitals')
  List<String>? get serviceHospitals => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_area')
  List<String>? get serviceArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'specialties')
  List<String>? get specialties => throw _privateConstructorUsedError;
  @JsonKey(name: 'certificates')
  List<String>? get certificates => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanionCopyWith<Companion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanionCopyWith<$Res> {
  factory $CompanionCopyWith(Companion value, $Res Function(Companion) then) =
      _$CompanionCopyWithImpl<$Res, Companion>;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String? gender,
      int? age,
      @JsonKey(name: 'institution_id') int? institutionId,
      @JsonKey(name: 'service_years') int? serviceYears,
      String? introduction,
      @JsonKey(name: 'has_car') bool hasCar,
      @JsonKey(name: 'car_type') String? carType,
      double rating,
      @JsonKey(name: 'review_count') int reviewCount,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'completed_orders') int completedOrders,
      String status,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'is_online') bool isOnline,
      @JsonKey(name: 'service_hospitals') List<String>? serviceHospitals,
      @JsonKey(name: 'service_area') List<String>? serviceArea,
      @JsonKey(name: 'specialties') List<String>? specialties,
      @JsonKey(name: 'certificates') List<String>? certificates,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$CompanionCopyWithImpl<$Res, $Val extends Companion>
    implements $CompanionCopyWith<$Res> {
  _$CompanionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? gender = freezed,
    Object? age = freezed,
    Object? institutionId = freezed,
    Object? serviceYears = freezed,
    Object? introduction = freezed,
    Object? hasCar = null,
    Object? carType = freezed,
    Object? rating = null,
    Object? reviewCount = null,
    Object? totalOrders = null,
    Object? completedOrders = null,
    Object? status = null,
    Object? isVerified = null,
    Object? isOnline = null,
    Object? serviceHospitals = freezed,
    Object? serviceArea = freezed,
    Object? specialties = freezed,
    Object? certificates = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      institutionId: freezed == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceYears: freezed == serviceYears
          ? _value.serviceYears
          : serviceYears // ignore: cast_nullable_to_non_nullable
              as int?,
      introduction: freezed == introduction
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String?,
      hasCar: null == hasCar
          ? _value.hasCar
          : hasCar // ignore: cast_nullable_to_non_nullable
              as bool,
      carType: freezed == carType
          ? _value.carType
          : carType // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      serviceHospitals: freezed == serviceHospitals
          ? _value.serviceHospitals
          : serviceHospitals // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      serviceArea: freezed == serviceArea
          ? _value.serviceArea
          : serviceArea // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      specialties: freezed == specialties
          ? _value.specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      certificates: freezed == certificates
          ? _value.certificates
          : certificates // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanionImplCopyWith<$Res>
    implements $CompanionCopyWith<$Res> {
  factory _$$CompanionImplCopyWith(
          _$CompanionImpl value, $Res Function(_$CompanionImpl) then) =
      __$$CompanionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String? gender,
      int? age,
      @JsonKey(name: 'institution_id') int? institutionId,
      @JsonKey(name: 'service_years') int? serviceYears,
      String? introduction,
      @JsonKey(name: 'has_car') bool hasCar,
      @JsonKey(name: 'car_type') String? carType,
      double rating,
      @JsonKey(name: 'review_count') int reviewCount,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'completed_orders') int completedOrders,
      String status,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'is_online') bool isOnline,
      @JsonKey(name: 'service_hospitals') List<String>? serviceHospitals,
      @JsonKey(name: 'service_area') List<String>? serviceArea,
      @JsonKey(name: 'specialties') List<String>? specialties,
      @JsonKey(name: 'certificates') List<String>? certificates,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$CompanionImplCopyWithImpl<$Res>
    extends _$CompanionCopyWithImpl<$Res, _$CompanionImpl>
    implements _$$CompanionImplCopyWith<$Res> {
  __$$CompanionImplCopyWithImpl(
      _$CompanionImpl _value, $Res Function(_$CompanionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? gender = freezed,
    Object? age = freezed,
    Object? institutionId = freezed,
    Object? serviceYears = freezed,
    Object? introduction = freezed,
    Object? hasCar = null,
    Object? carType = freezed,
    Object? rating = null,
    Object? reviewCount = null,
    Object? totalOrders = null,
    Object? completedOrders = null,
    Object? status = null,
    Object? isVerified = null,
    Object? isOnline = null,
    Object? serviceHospitals = freezed,
    Object? serviceArea = freezed,
    Object? specialties = freezed,
    Object? certificates = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$CompanionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      institutionId: freezed == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceYears: freezed == serviceYears
          ? _value.serviceYears
          : serviceYears // ignore: cast_nullable_to_non_nullable
              as int?,
      introduction: freezed == introduction
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String?,
      hasCar: null == hasCar
          ? _value.hasCar
          : hasCar // ignore: cast_nullable_to_non_nullable
              as bool,
      carType: freezed == carType
          ? _value.carType
          : carType // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      serviceHospitals: freezed == serviceHospitals
          ? _value._serviceHospitals
          : serviceHospitals // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      serviceArea: freezed == serviceArea
          ? _value._serviceArea
          : serviceArea // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      specialties: freezed == specialties
          ? _value._specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      certificates: freezed == certificates
          ? _value._certificates
          : certificates // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanionImpl implements _Companion {
  const _$CompanionImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      this.gender,
      this.age,
      @JsonKey(name: 'institution_id') this.institutionId,
      @JsonKey(name: 'service_years') this.serviceYears,
      this.introduction,
      @JsonKey(name: 'has_car') this.hasCar = false,
      @JsonKey(name: 'car_type') this.carType,
      this.rating = 5.0,
      @JsonKey(name: 'review_count') this.reviewCount = 0,
      @JsonKey(name: 'total_orders') this.totalOrders = 0,
      @JsonKey(name: 'completed_orders') this.completedOrders = 0,
      this.status = 'approved',
      @JsonKey(name: 'is_verified') this.isVerified = false,
      @JsonKey(name: 'is_online') this.isOnline = false,
      @JsonKey(name: 'service_hospitals') final List<String>? serviceHospitals,
      @JsonKey(name: 'service_area') final List<String>? serviceArea,
      @JsonKey(name: 'specialties') final List<String>? specialties,
      @JsonKey(name: 'certificates') final List<String>? certificates,
      @JsonKey(name: 'created_at') this.createdAt})
      : _serviceHospitals = serviceHospitals,
        _serviceArea = serviceArea,
        _specialties = specialties,
        _certificates = certificates;

  factory _$CompanionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanionImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  final String? gender;
  @override
  final int? age;
  @override
  @JsonKey(name: 'institution_id')
  final int? institutionId;
  @override
  @JsonKey(name: 'service_years')
  final int? serviceYears;
  @override
  final String? introduction;
  @override
  @JsonKey(name: 'has_car')
  final bool hasCar;
  @override
  @JsonKey(name: 'car_type')
  final String? carType;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey(name: 'review_count')
  final int reviewCount;
  @override
  @JsonKey(name: 'total_orders')
  final int totalOrders;
  @override
  @JsonKey(name: 'completed_orders')
  final int completedOrders;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @override
  @JsonKey(name: 'is_online')
  final bool isOnline;
  final List<String>? _serviceHospitals;
  @override
  @JsonKey(name: 'service_hospitals')
  List<String>? get serviceHospitals {
    final value = _serviceHospitals;
    if (value == null) return null;
    if (_serviceHospitals is EqualUnmodifiableListView)
      return _serviceHospitals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _serviceArea;
  @override
  @JsonKey(name: 'service_area')
  List<String>? get serviceArea {
    final value = _serviceArea;
    if (value == null) return null;
    if (_serviceArea is EqualUnmodifiableListView) return _serviceArea;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _specialties;
  @override
  @JsonKey(name: 'specialties')
  List<String>? get specialties {
    final value = _specialties;
    if (value == null) return null;
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _certificates;
  @override
  @JsonKey(name: 'certificates')
  List<String>? get certificates {
    final value = _certificates;
    if (value == null) return null;
    if (_certificates is EqualUnmodifiableListView) return _certificates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Companion(id: $id, name: $name, avatarUrl: $avatarUrl, gender: $gender, age: $age, institutionId: $institutionId, serviceYears: $serviceYears, introduction: $introduction, hasCar: $hasCar, carType: $carType, rating: $rating, reviewCount: $reviewCount, totalOrders: $totalOrders, completedOrders: $completedOrders, status: $status, isVerified: $isVerified, isOnline: $isOnline, serviceHospitals: $serviceHospitals, serviceArea: $serviceArea, specialties: $specialties, certificates: $certificates, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.institutionId, institutionId) ||
                other.institutionId == institutionId) &&
            (identical(other.serviceYears, serviceYears) ||
                other.serviceYears == serviceYears) &&
            (identical(other.introduction, introduction) ||
                other.introduction == introduction) &&
            (identical(other.hasCar, hasCar) || other.hasCar == hasCar) &&
            (identical(other.carType, carType) || other.carType == carType) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.completedOrders, completedOrders) ||
                other.completedOrders == completedOrders) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            const DeepCollectionEquality()
                .equals(other._serviceHospitals, _serviceHospitals) &&
            const DeepCollectionEquality()
                .equals(other._serviceArea, _serviceArea) &&
            const DeepCollectionEquality()
                .equals(other._specialties, _specialties) &&
            const DeepCollectionEquality()
                .equals(other._certificates, _certificates) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        avatarUrl,
        gender,
        age,
        institutionId,
        serviceYears,
        introduction,
        hasCar,
        carType,
        rating,
        reviewCount,
        totalOrders,
        completedOrders,
        status,
        isVerified,
        isOnline,
        const DeepCollectionEquality().hash(_serviceHospitals),
        const DeepCollectionEquality().hash(_serviceArea),
        const DeepCollectionEquality().hash(_specialties),
        const DeepCollectionEquality().hash(_certificates),
        createdAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanionImplCopyWith<_$CompanionImpl> get copyWith =>
      __$$CompanionImplCopyWithImpl<_$CompanionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanionImplToJson(
      this,
    );
  }
}

abstract class _Companion implements Companion {
  const factory _Companion(
      {required final int id,
      required final String name,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      final String? gender,
      final int? age,
      @JsonKey(name: 'institution_id') final int? institutionId,
      @JsonKey(name: 'service_years') final int? serviceYears,
      final String? introduction,
      @JsonKey(name: 'has_car') final bool hasCar,
      @JsonKey(name: 'car_type') final String? carType,
      final double rating,
      @JsonKey(name: 'review_count') final int reviewCount,
      @JsonKey(name: 'total_orders') final int totalOrders,
      @JsonKey(name: 'completed_orders') final int completedOrders,
      final String status,
      @JsonKey(name: 'is_verified') final bool isVerified,
      @JsonKey(name: 'is_online') final bool isOnline,
      @JsonKey(name: 'service_hospitals') final List<String>? serviceHospitals,
      @JsonKey(name: 'service_area') final List<String>? serviceArea,
      @JsonKey(name: 'specialties') final List<String>? specialties,
      @JsonKey(name: 'certificates') final List<String>? certificates,
      @JsonKey(name: 'created_at')
      final DateTime? createdAt}) = _$CompanionImpl;

  factory _Companion.fromJson(Map<String, dynamic> json) =
      _$CompanionImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  String? get gender;
  @override
  int? get age;
  @override
  @JsonKey(name: 'institution_id')
  int? get institutionId;
  @override
  @JsonKey(name: 'service_years')
  int? get serviceYears;
  @override
  String? get introduction;
  @override
  @JsonKey(name: 'has_car')
  bool get hasCar;
  @override
  @JsonKey(name: 'car_type')
  String? get carType;
  @override
  double get rating;
  @override
  @JsonKey(name: 'review_count')
  int get reviewCount;
  @override
  @JsonKey(name: 'total_orders')
  int get totalOrders;
  @override
  @JsonKey(name: 'completed_orders')
  int get completedOrders;
  @override
  String get status;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  @JsonKey(name: 'is_online')
  bool get isOnline;
  @override
  @JsonKey(name: 'service_hospitals')
  List<String>? get serviceHospitals;
  @override
  @JsonKey(name: 'service_area')
  List<String>? get serviceArea;
  @override
  @JsonKey(name: 'specialties')
  List<String>? get specialties;
  @override
  @JsonKey(name: 'certificates')
  List<String>? get certificates;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$CompanionImplCopyWith<_$CompanionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanionRecommendation _$CompanionRecommendationFromJson(
    Map<String, dynamic> json) {
  return _CompanionRecommendation.fromJson(json);
}

/// @nodoc
mixin _$CompanionRecommendation {
  Companion get companion => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_score')
  double? get matchScore => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanionRecommendationCopyWith<CompanionRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanionRecommendationCopyWith<$Res> {
  factory $CompanionRecommendationCopyWith(CompanionRecommendation value,
          $Res Function(CompanionRecommendation) then) =
      _$CompanionRecommendationCopyWithImpl<$Res, CompanionRecommendation>;
  @useResult
  $Res call(
      {Companion companion,
      @JsonKey(name: 'match_score') double? matchScore,
      String? reason});

  $CompanionCopyWith<$Res> get companion;
}

/// @nodoc
class _$CompanionRecommendationCopyWithImpl<$Res,
        $Val extends CompanionRecommendation>
    implements $CompanionRecommendationCopyWith<$Res> {
  _$CompanionRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companion = null,
    Object? matchScore = freezed,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      companion: null == companion
          ? _value.companion
          : companion // ignore: cast_nullable_to_non_nullable
              as Companion,
      matchScore: freezed == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as double?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CompanionCopyWith<$Res> get companion {
    return $CompanionCopyWith<$Res>(_value.companion, (value) {
      return _then(_value.copyWith(companion: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompanionRecommendationImplCopyWith<$Res>
    implements $CompanionRecommendationCopyWith<$Res> {
  factory _$$CompanionRecommendationImplCopyWith(
          _$CompanionRecommendationImpl value,
          $Res Function(_$CompanionRecommendationImpl) then) =
      __$$CompanionRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Companion companion,
      @JsonKey(name: 'match_score') double? matchScore,
      String? reason});

  @override
  $CompanionCopyWith<$Res> get companion;
}

/// @nodoc
class __$$CompanionRecommendationImplCopyWithImpl<$Res>
    extends _$CompanionRecommendationCopyWithImpl<$Res,
        _$CompanionRecommendationImpl>
    implements _$$CompanionRecommendationImplCopyWith<$Res> {
  __$$CompanionRecommendationImplCopyWithImpl(
      _$CompanionRecommendationImpl _value,
      $Res Function(_$CompanionRecommendationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companion = null,
    Object? matchScore = freezed,
    Object? reason = freezed,
  }) {
    return _then(_$CompanionRecommendationImpl(
      companion: null == companion
          ? _value.companion
          : companion // ignore: cast_nullable_to_non_nullable
              as Companion,
      matchScore: freezed == matchScore
          ? _value.matchScore
          : matchScore // ignore: cast_nullable_to_non_nullable
              as double?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanionRecommendationImpl implements _CompanionRecommendation {
  const _$CompanionRecommendationImpl(
      {required this.companion,
      @JsonKey(name: 'match_score') this.matchScore,
      this.reason});

  factory _$CompanionRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanionRecommendationImplFromJson(json);

  @override
  final Companion companion;
  @override
  @JsonKey(name: 'match_score')
  final double? matchScore;
  @override
  final String? reason;

  @override
  String toString() {
    return 'CompanionRecommendation(companion: $companion, matchScore: $matchScore, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanionRecommendationImpl &&
            (identical(other.companion, companion) ||
                other.companion == companion) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, companion, matchScore, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanionRecommendationImplCopyWith<_$CompanionRecommendationImpl>
      get copyWith => __$$CompanionRecommendationImplCopyWithImpl<
          _$CompanionRecommendationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanionRecommendationImplToJson(
      this,
    );
  }
}

abstract class _CompanionRecommendation implements CompanionRecommendation {
  const factory _CompanionRecommendation(
      {required final Companion companion,
      @JsonKey(name: 'match_score') final double? matchScore,
      final String? reason}) = _$CompanionRecommendationImpl;

  factory _CompanionRecommendation.fromJson(Map<String, dynamic> json) =
      _$CompanionRecommendationImpl.fromJson;

  @override
  Companion get companion;
  @override
  @JsonKey(name: 'match_score')
  double? get matchScore;
  @override
  String? get reason;
  @override
  @JsonKey(ignore: true)
  _$$CompanionRecommendationImplCopyWith<_$CompanionRecommendationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
