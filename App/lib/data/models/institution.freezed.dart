// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'institution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Institution _$InstitutionFromJson(Map<String, dynamic> json) {
  return _Institution.fromJson(json);
}

/// @nodoc
mixin _$Institution {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;

  /// 关联的用户ID（用于即时通讯）
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_url')
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_license')
  String? get businessLicense => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _doubleFromJson)
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_count')
  int get reviewCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_orders')
  int get totalOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_orders')
  int get completedOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'companion_count')
  int get companionCount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_hospitals')
  List<String>? get serviceHospitals => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_area')
  List<String>? get serviceArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InstitutionCopyWith<Institution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstitutionCopyWith<$Res> {
  factory $InstitutionCopyWith(
          Institution value, $Res Function(Institution) then) =
      _$InstitutionCopyWithImpl<$Res, Institution>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'user_id') int? userId,
      String name,
      @JsonKey(name: 'logo_url') String? logoUrl,
      String? description,
      String? address,
      String? phone,
      String? city,
      @JsonKey(name: 'business_license') String? businessLicense,
      @JsonKey(fromJson: _doubleFromJson) double rating,
      @JsonKey(name: 'review_count') int reviewCount,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'completed_orders') int completedOrders,
      @JsonKey(name: 'companion_count') int companionCount,
      String status,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'service_hospitals') List<String>? serviceHospitals,
      @JsonKey(name: 'service_area') List<String>? serviceArea,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$InstitutionCopyWithImpl<$Res, $Val extends Institution>
    implements $InstitutionCopyWith<$Res> {
  _$InstitutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? description = freezed,
    Object? address = freezed,
    Object? phone = freezed,
    Object? city = freezed,
    Object? businessLicense = freezed,
    Object? rating = null,
    Object? reviewCount = null,
    Object? totalOrders = null,
    Object? completedOrders = null,
    Object? companionCount = null,
    Object? status = null,
    Object? isVerified = null,
    Object? serviceHospitals = freezed,
    Object? serviceArea = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      businessLicense: freezed == businessLicense
          ? _value.businessLicense
          : businessLicense // ignore: cast_nullable_to_non_nullable
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
      companionCount: null == companionCount
          ? _value.companionCount
          : companionCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      serviceHospitals: freezed == serviceHospitals
          ? _value.serviceHospitals
          : serviceHospitals // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      serviceArea: freezed == serviceArea
          ? _value.serviceArea
          : serviceArea // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstitutionImplCopyWith<$Res>
    implements $InstitutionCopyWith<$Res> {
  factory _$$InstitutionImplCopyWith(
          _$InstitutionImpl value, $Res Function(_$InstitutionImpl) then) =
      __$$InstitutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'user_id') int? userId,
      String name,
      @JsonKey(name: 'logo_url') String? logoUrl,
      String? description,
      String? address,
      String? phone,
      String? city,
      @JsonKey(name: 'business_license') String? businessLicense,
      @JsonKey(fromJson: _doubleFromJson) double rating,
      @JsonKey(name: 'review_count') int reviewCount,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'completed_orders') int completedOrders,
      @JsonKey(name: 'companion_count') int companionCount,
      String status,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'service_hospitals') List<String>? serviceHospitals,
      @JsonKey(name: 'service_area') List<String>? serviceArea,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$InstitutionImplCopyWithImpl<$Res>
    extends _$InstitutionCopyWithImpl<$Res, _$InstitutionImpl>
    implements _$$InstitutionImplCopyWith<$Res> {
  __$$InstitutionImplCopyWithImpl(
      _$InstitutionImpl _value, $Res Function(_$InstitutionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? description = freezed,
    Object? address = freezed,
    Object? phone = freezed,
    Object? city = freezed,
    Object? businessLicense = freezed,
    Object? rating = null,
    Object? reviewCount = null,
    Object? totalOrders = null,
    Object? completedOrders = null,
    Object? companionCount = null,
    Object? status = null,
    Object? isVerified = null,
    Object? serviceHospitals = freezed,
    Object? serviceArea = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$InstitutionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      businessLicense: freezed == businessLicense
          ? _value.businessLicense
          : businessLicense // ignore: cast_nullable_to_non_nullable
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
      companionCount: null == companionCount
          ? _value.companionCount
          : companionCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      serviceHospitals: freezed == serviceHospitals
          ? _value._serviceHospitals
          : serviceHospitals // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      serviceArea: freezed == serviceArea
          ? _value._serviceArea
          : serviceArea // ignore: cast_nullable_to_non_nullable
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
class _$InstitutionImpl implements _Institution {
  const _$InstitutionImpl(
      {@JsonKey(fromJson: _intFromJson) this.id = 0,
      @JsonKey(name: 'user_id') this.userId,
      this.name = '',
      @JsonKey(name: 'logo_url') this.logoUrl,
      this.description,
      this.address,
      this.phone,
      this.city,
      @JsonKey(name: 'business_license') this.businessLicense,
      @JsonKey(fromJson: _doubleFromJson) this.rating = 5.0,
      @JsonKey(name: 'review_count') this.reviewCount = 0,
      @JsonKey(name: 'total_orders') this.totalOrders = 0,
      @JsonKey(name: 'completed_orders') this.completedOrders = 0,
      @JsonKey(name: 'companion_count') this.companionCount = 0,
      this.status = 'approved',
      @JsonKey(name: 'is_verified') this.isVerified = false,
      @JsonKey(name: 'service_hospitals') final List<String>? serviceHospitals,
      @JsonKey(name: 'service_area') final List<String>? serviceArea,
      @JsonKey(name: 'created_at') this.createdAt})
      : _serviceHospitals = serviceHospitals,
        _serviceArea = serviceArea;

  factory _$InstitutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstitutionImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;

  /// 关联的用户ID（用于即时通讯）
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @override
  final String? description;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  final String? city;
  @override
  @JsonKey(name: 'business_license')
  final String? businessLicense;
  @override
  @JsonKey(fromJson: _doubleFromJson)
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
  @JsonKey(name: 'companion_count')
  final int companionCount;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;
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

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Institution(id: $id, userId: $userId, name: $name, logoUrl: $logoUrl, description: $description, address: $address, phone: $phone, city: $city, businessLicense: $businessLicense, rating: $rating, reviewCount: $reviewCount, totalOrders: $totalOrders, completedOrders: $completedOrders, companionCount: $companionCount, status: $status, isVerified: $isVerified, serviceHospitals: $serviceHospitals, serviceArea: $serviceArea, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstitutionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.businessLicense, businessLicense) ||
                other.businessLicense == businessLicense) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.completedOrders, completedOrders) ||
                other.completedOrders == completedOrders) &&
            (identical(other.companionCount, companionCount) ||
                other.companionCount == companionCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            const DeepCollectionEquality()
                .equals(other._serviceHospitals, _serviceHospitals) &&
            const DeepCollectionEquality()
                .equals(other._serviceArea, _serviceArea) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        name,
        logoUrl,
        description,
        address,
        phone,
        city,
        businessLicense,
        rating,
        reviewCount,
        totalOrders,
        completedOrders,
        companionCount,
        status,
        isVerified,
        const DeepCollectionEquality().hash(_serviceHospitals),
        const DeepCollectionEquality().hash(_serviceArea),
        createdAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstitutionImplCopyWith<_$InstitutionImpl> get copyWith =>
      __$$InstitutionImplCopyWithImpl<_$InstitutionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstitutionImplToJson(
      this,
    );
  }
}

abstract class _Institution implements Institution {
  const factory _Institution(
      {@JsonKey(fromJson: _intFromJson) final int id,
      @JsonKey(name: 'user_id') final int? userId,
      final String name,
      @JsonKey(name: 'logo_url') final String? logoUrl,
      final String? description,
      final String? address,
      final String? phone,
      final String? city,
      @JsonKey(name: 'business_license') final String? businessLicense,
      @JsonKey(fromJson: _doubleFromJson) final double rating,
      @JsonKey(name: 'review_count') final int reviewCount,
      @JsonKey(name: 'total_orders') final int totalOrders,
      @JsonKey(name: 'completed_orders') final int completedOrders,
      @JsonKey(name: 'companion_count') final int companionCount,
      final String status,
      @JsonKey(name: 'is_verified') final bool isVerified,
      @JsonKey(name: 'service_hospitals') final List<String>? serviceHospitals,
      @JsonKey(name: 'service_area') final List<String>? serviceArea,
      @JsonKey(name: 'created_at')
      final DateTime? createdAt}) = _$InstitutionImpl;

  factory _Institution.fromJson(Map<String, dynamic> json) =
      _$InstitutionImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override

  /// 关联的用户ID（用于即时通讯）
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  String get name;
  @override
  @JsonKey(name: 'logo_url')
  String? get logoUrl;
  @override
  String? get description;
  @override
  String? get address;
  @override
  String? get phone;
  @override
  String? get city;
  @override
  @JsonKey(name: 'business_license')
  String? get businessLicense;
  @override
  @JsonKey(fromJson: _doubleFromJson)
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
  @JsonKey(name: 'companion_count')
  int get companionCount;
  @override
  String get status;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  @JsonKey(name: 'service_hospitals')
  List<String>? get serviceHospitals;
  @override
  @JsonKey(name: 'service_area')
  List<String>? get serviceArea;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$InstitutionImplCopyWith<_$InstitutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InstitutionRecommendation _$InstitutionRecommendationFromJson(
    Map<String, dynamic> json) {
  return _InstitutionRecommendation.fromJson(json);
}

/// @nodoc
mixin _$InstitutionRecommendation {
  Institution get institution => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_score')
  double? get matchScore => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InstitutionRecommendationCopyWith<InstitutionRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstitutionRecommendationCopyWith<$Res> {
  factory $InstitutionRecommendationCopyWith(InstitutionRecommendation value,
          $Res Function(InstitutionRecommendation) then) =
      _$InstitutionRecommendationCopyWithImpl<$Res, InstitutionRecommendation>;
  @useResult
  $Res call(
      {Institution institution,
      @JsonKey(name: 'match_score') double? matchScore,
      String? reason});

  $InstitutionCopyWith<$Res> get institution;
}

/// @nodoc
class _$InstitutionRecommendationCopyWithImpl<$Res,
        $Val extends InstitutionRecommendation>
    implements $InstitutionRecommendationCopyWith<$Res> {
  _$InstitutionRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? institution = null,
    Object? matchScore = freezed,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      institution: null == institution
          ? _value.institution
          : institution // ignore: cast_nullable_to_non_nullable
              as Institution,
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
  $InstitutionCopyWith<$Res> get institution {
    return $InstitutionCopyWith<$Res>(_value.institution, (value) {
      return _then(_value.copyWith(institution: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InstitutionRecommendationImplCopyWith<$Res>
    implements $InstitutionRecommendationCopyWith<$Res> {
  factory _$$InstitutionRecommendationImplCopyWith(
          _$InstitutionRecommendationImpl value,
          $Res Function(_$InstitutionRecommendationImpl) then) =
      __$$InstitutionRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Institution institution,
      @JsonKey(name: 'match_score') double? matchScore,
      String? reason});

  @override
  $InstitutionCopyWith<$Res> get institution;
}

/// @nodoc
class __$$InstitutionRecommendationImplCopyWithImpl<$Res>
    extends _$InstitutionRecommendationCopyWithImpl<$Res,
        _$InstitutionRecommendationImpl>
    implements _$$InstitutionRecommendationImplCopyWith<$Res> {
  __$$InstitutionRecommendationImplCopyWithImpl(
      _$InstitutionRecommendationImpl _value,
      $Res Function(_$InstitutionRecommendationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? institution = null,
    Object? matchScore = freezed,
    Object? reason = freezed,
  }) {
    return _then(_$InstitutionRecommendationImpl(
      institution: null == institution
          ? _value.institution
          : institution // ignore: cast_nullable_to_non_nullable
              as Institution,
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
class _$InstitutionRecommendationImpl implements _InstitutionRecommendation {
  const _$InstitutionRecommendationImpl(
      {required this.institution,
      @JsonKey(name: 'match_score') this.matchScore,
      this.reason});

  factory _$InstitutionRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstitutionRecommendationImplFromJson(json);

  @override
  final Institution institution;
  @override
  @JsonKey(name: 'match_score')
  final double? matchScore;
  @override
  final String? reason;

  @override
  String toString() {
    return 'InstitutionRecommendation(institution: $institution, matchScore: $matchScore, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstitutionRecommendationImpl &&
            (identical(other.institution, institution) ||
                other.institution == institution) &&
            (identical(other.matchScore, matchScore) ||
                other.matchScore == matchScore) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, institution, matchScore, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstitutionRecommendationImplCopyWith<_$InstitutionRecommendationImpl>
      get copyWith => __$$InstitutionRecommendationImplCopyWithImpl<
          _$InstitutionRecommendationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstitutionRecommendationImplToJson(
      this,
    );
  }
}

abstract class _InstitutionRecommendation implements InstitutionRecommendation {
  const factory _InstitutionRecommendation(
      {required final Institution institution,
      @JsonKey(name: 'match_score') final double? matchScore,
      final String? reason}) = _$InstitutionRecommendationImpl;

  factory _InstitutionRecommendation.fromJson(Map<String, dynamic> json) =
      _$InstitutionRecommendationImpl.fromJson;

  @override
  Institution get institution;
  @override
  @JsonKey(name: 'match_score')
  double? get matchScore;
  @override
  String? get reason;
  @override
  @JsonKey(ignore: true)
  _$$InstitutionRecommendationImplCopyWith<_$InstitutionRecommendationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
