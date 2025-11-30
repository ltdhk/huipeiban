// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  int get id => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate => throw _privateConstructorUsedError; // 用户类型
  @JsonKey(name: 'user_type', defaultValue: 'patient')
  String get userType => throw _privateConstructorUsedError; // 陪诊师关联信息
  @JsonKey(name: 'companion_id')
  int? get companionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'companion_info')
  Map<String, dynamic>? get companionInfo =>
      throw _privateConstructorUsedError; // 机构关联信息
  @JsonKey(name: 'institution_id')
  int? get institutionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'institution_info')
  Map<String, dynamic>? get institutionInfo =>
      throw _privateConstructorUsedError; // 账户信息
  double get balance => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_level')
  String get memberLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_orders')
  int get totalOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spent')
  double get totalSpent => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login_at')
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {int id,
      String? phone,
      String? nickname,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String? gender,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      @JsonKey(name: 'user_type', defaultValue: 'patient') String userType,
      @JsonKey(name: 'companion_id') int? companionId,
      @JsonKey(name: 'companion_info') Map<String, dynamic>? companionInfo,
      @JsonKey(name: 'institution_id') int? institutionId,
      @JsonKey(name: 'institution_info') Map<String, dynamic>? institutionInfo,
      double balance,
      int points,
      @JsonKey(name: 'member_level') String memberLevel,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'total_spent') double totalSpent,
      String status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'last_login_at') DateTime? lastLoginAt});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = freezed,
    Object? nickname = freezed,
    Object? avatarUrl = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? userType = null,
    Object? companionId = freezed,
    Object? companionInfo = freezed,
    Object? institutionId = freezed,
    Object? institutionInfo = freezed,
    Object? balance = null,
    Object? points = null,
    Object? memberLevel = null,
    Object? totalOrders = null,
    Object? totalSpent = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? lastLoginAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as String,
      companionId: freezed == companionId
          ? _value.companionId
          : companionId // ignore: cast_nullable_to_non_nullable
              as int?,
      companionInfo: freezed == companionInfo
          ? _value.companionInfo
          : companionInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      institutionId: freezed == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as int?,
      institutionInfo: freezed == institutionInfo
          ? _value.institutionInfo
          : institutionInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      memberLevel: null == memberLevel
          ? _value.memberLevel
          : memberLevel // ignore: cast_nullable_to_non_nullable
              as String,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? phone,
      String? nickname,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String? gender,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      @JsonKey(name: 'user_type', defaultValue: 'patient') String userType,
      @JsonKey(name: 'companion_id') int? companionId,
      @JsonKey(name: 'companion_info') Map<String, dynamic>? companionInfo,
      @JsonKey(name: 'institution_id') int? institutionId,
      @JsonKey(name: 'institution_info') Map<String, dynamic>? institutionInfo,
      double balance,
      int points,
      @JsonKey(name: 'member_level') String memberLevel,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'total_spent') double totalSpent,
      String status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'last_login_at') DateTime? lastLoginAt});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = freezed,
    Object? nickname = freezed,
    Object? avatarUrl = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? userType = null,
    Object? companionId = freezed,
    Object? companionInfo = freezed,
    Object? institutionId = freezed,
    Object? institutionInfo = freezed,
    Object? balance = null,
    Object? points = null,
    Object? memberLevel = null,
    Object? totalOrders = null,
    Object? totalSpent = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? lastLoginAt = freezed,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as String,
      companionId: freezed == companionId
          ? _value.companionId
          : companionId // ignore: cast_nullable_to_non_nullable
              as int?,
      companionInfo: freezed == companionInfo
          ? _value._companionInfo
          : companionInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      institutionId: freezed == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as int?,
      institutionInfo: freezed == institutionInfo
          ? _value._institutionInfo
          : institutionInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      memberLevel: null == memberLevel
          ? _value.memberLevel
          : memberLevel // ignore: cast_nullable_to_non_nullable
              as String,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl(
      {required this.id,
      this.phone,
      this.nickname,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      this.gender,
      @JsonKey(name: 'birth_date') this.birthDate,
      @JsonKey(name: 'user_type', defaultValue: 'patient')
      this.userType = 'patient',
      @JsonKey(name: 'companion_id') this.companionId,
      @JsonKey(name: 'companion_info')
      final Map<String, dynamic>? companionInfo,
      @JsonKey(name: 'institution_id') this.institutionId,
      @JsonKey(name: 'institution_info')
      final Map<String, dynamic>? institutionInfo,
      this.balance = 0.0,
      this.points = 0,
      @JsonKey(name: 'member_level') this.memberLevel = '普通会员',
      @JsonKey(name: 'total_orders') this.totalOrders = 0,
      @JsonKey(name: 'total_spent') this.totalSpent = 0.0,
      this.status = 'active',
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'last_login_at') this.lastLoginAt})
      : _companionInfo = companionInfo,
        _institutionInfo = institutionInfo,
        super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final int id;
  @override
  final String? phone;
  @override
  final String? nickname;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  final String? gender;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
// 用户类型
  @override
  @JsonKey(name: 'user_type', defaultValue: 'patient')
  final String userType;
// 陪诊师关联信息
  @override
  @JsonKey(name: 'companion_id')
  final int? companionId;
  final Map<String, dynamic>? _companionInfo;
  @override
  @JsonKey(name: 'companion_info')
  Map<String, dynamic>? get companionInfo {
    final value = _companionInfo;
    if (value == null) return null;
    if (_companionInfo is EqualUnmodifiableMapView) return _companionInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// 机构关联信息
  @override
  @JsonKey(name: 'institution_id')
  final int? institutionId;
  final Map<String, dynamic>? _institutionInfo;
  @override
  @JsonKey(name: 'institution_info')
  Map<String, dynamic>? get institutionInfo {
    final value = _institutionInfo;
    if (value == null) return null;
    if (_institutionInfo is EqualUnmodifiableMapView) return _institutionInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// 账户信息
  @override
  @JsonKey()
  final double balance;
  @override
  @JsonKey()
  final int points;
  @override
  @JsonKey(name: 'member_level')
  final String memberLevel;
  @override
  @JsonKey(name: 'total_orders')
  final int totalOrders;
  @override
  @JsonKey(name: 'total_spent')
  final double totalSpent;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;

  @override
  String toString() {
    return 'User(id: $id, phone: $phone, nickname: $nickname, avatarUrl: $avatarUrl, gender: $gender, birthDate: $birthDate, userType: $userType, companionId: $companionId, companionInfo: $companionInfo, institutionId: $institutionId, institutionInfo: $institutionInfo, balance: $balance, points: $points, memberLevel: $memberLevel, totalOrders: $totalOrders, totalSpent: $totalSpent, status: $status, createdAt: $createdAt, lastLoginAt: $lastLoginAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.companionId, companionId) ||
                other.companionId == companionId) &&
            const DeepCollectionEquality()
                .equals(other._companionInfo, _companionInfo) &&
            (identical(other.institutionId, institutionId) ||
                other.institutionId == institutionId) &&
            const DeepCollectionEquality()
                .equals(other._institutionInfo, _institutionInfo) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.memberLevel, memberLevel) ||
                other.memberLevel == memberLevel) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        phone,
        nickname,
        avatarUrl,
        gender,
        birthDate,
        userType,
        companionId,
        const DeepCollectionEquality().hash(_companionInfo),
        institutionId,
        const DeepCollectionEquality().hash(_institutionInfo),
        balance,
        points,
        memberLevel,
        totalOrders,
        totalSpent,
        status,
        createdAt,
        lastLoginAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User extends User {
  const factory _User(
          {required final int id,
          final String? phone,
          final String? nickname,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          final String? gender,
          @JsonKey(name: 'birth_date') final DateTime? birthDate,
          @JsonKey(name: 'user_type', defaultValue: 'patient')
          final String userType,
          @JsonKey(name: 'companion_id') final int? companionId,
          @JsonKey(name: 'companion_info')
          final Map<String, dynamic>? companionInfo,
          @JsonKey(name: 'institution_id') final int? institutionId,
          @JsonKey(name: 'institution_info')
          final Map<String, dynamic>? institutionInfo,
          final double balance,
          final int points,
          @JsonKey(name: 'member_level') final String memberLevel,
          @JsonKey(name: 'total_orders') final int totalOrders,
          @JsonKey(name: 'total_spent') final double totalSpent,
          final String status,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'last_login_at') final DateTime? lastLoginAt}) =
      _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  int get id;
  @override
  String? get phone;
  @override
  String? get nickname;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  String? get gender;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate;
  @override // 用户类型
  @JsonKey(name: 'user_type', defaultValue: 'patient')
  String get userType;
  @override // 陪诊师关联信息
  @JsonKey(name: 'companion_id')
  int? get companionId;
  @override
  @JsonKey(name: 'companion_info')
  Map<String, dynamic>? get companionInfo;
  @override // 机构关联信息
  @JsonKey(name: 'institution_id')
  int? get institutionId;
  @override
  @JsonKey(name: 'institution_info')
  Map<String, dynamic>? get institutionInfo;
  @override // 账户信息
  double get balance;
  @override
  int get points;
  @override
  @JsonKey(name: 'member_level')
  String get memberLevel;
  @override
  @JsonKey(name: 'total_orders')
  int get totalOrders;
  @override
  @JsonKey(name: 'total_spent')
  double get totalSpent;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'last_login_at')
  DateTime? get lastLoginAt;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return _AuthResponse.fromJson(json);
}

/// @nodoc
mixin _$AuthResponse {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'token_type')
  String get tokenType => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_in')
  int get expiresIn => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthResponseCopyWith<AuthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
          AuthResponse value, $Res Function(AuthResponse) then) =
      _$AuthResponseCopyWithImpl<$Res, AuthResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'token_type') String tokenType,
      @JsonKey(name: 'expires_in') int expiresIn,
      User? user});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res, $Val extends AuthResponse>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthResponseImplCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory _$$AuthResponseImplCopyWith(
          _$AuthResponseImpl value, $Res Function(_$AuthResponseImpl) then) =
      __$$AuthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'token_type') String tokenType,
      @JsonKey(name: 'expires_in') int expiresIn,
      User? user});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AuthResponseImplCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$AuthResponseImpl>
    implements _$$AuthResponseImplCopyWith<$Res> {
  __$$AuthResponseImplCopyWithImpl(
      _$AuthResponseImpl _value, $Res Function(_$AuthResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
    Object? user = freezed,
  }) {
    return _then(_$AuthResponseImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseImpl implements _AuthResponse {
  const _$AuthResponseImpl(
      {@JsonKey(name: 'access_token') required this.accessToken,
      @JsonKey(name: 'refresh_token') required this.refreshToken,
      @JsonKey(name: 'token_type') this.tokenType = 'Bearer',
      @JsonKey(name: 'expires_in') required this.expiresIn,
      this.user});

  factory _$AuthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  @JsonKey(name: 'token_type')
  final String tokenType;
  @override
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @override
  final User? user;

  @override
  String toString() {
    return 'AuthResponse(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, accessToken, refreshToken, tokenType, expiresIn, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      __$$AuthResponseImplCopyWithImpl<_$AuthResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseImplToJson(
      this,
    );
  }
}

abstract class _AuthResponse implements AuthResponse {
  const factory _AuthResponse(
      {@JsonKey(name: 'access_token') required final String accessToken,
      @JsonKey(name: 'refresh_token') required final String refreshToken,
      @JsonKey(name: 'token_type') final String tokenType,
      @JsonKey(name: 'expires_in') required final int expiresIn,
      final User? user}) = _$AuthResponseImpl;

  factory _AuthResponse.fromJson(Map<String, dynamic> json) =
      _$AuthResponseImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  @JsonKey(name: 'token_type')
  String get tokenType;
  @override
  @JsonKey(name: 'expires_in')
  int get expiresIn;
  @override
  User? get user;
  @override
  @JsonKey(ignore: true)
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
