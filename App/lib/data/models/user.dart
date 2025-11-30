import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 用户模型
@freezed
class User with _$User {
  const User._();

  const factory User({
    required int id,
    String? phone,
    String? nickname,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? gender,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    // 用户类型
    @JsonKey(name: 'user_type', defaultValue: 'patient') @Default('patient') String userType,
    // 陪诊师关联信息
    @JsonKey(name: 'companion_id') int? companionId,
    @JsonKey(name: 'companion_info') Map<String, dynamic>? companionInfo,
    // 机构关联信息
    @JsonKey(name: 'institution_id') int? institutionId,
    @JsonKey(name: 'institution_info') Map<String, dynamic>? institutionInfo,
    // 账户信息
    @Default(0.0) double balance,
    @Default(0) int points,
    @JsonKey(name: 'member_level') @Default('普通会员') String memberLevel,
    @JsonKey(name: 'total_orders') @Default(0) int totalOrders,
    @JsonKey(name: 'total_spent') @Default(0.0) double totalSpent,
    @Default('active') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// 是否为普通用户
  bool get isPatient => userType == 'patient';

  /// 是否为陪诊师
  bool get isCompanion => userType == 'companion';

  /// 是否为机构
  bool get isInstitution => userType == 'institution';

  /// 是否有陪诊管理权限
  bool get hasCompanionManagement => isCompanion || isInstitution;
}

/// 认证响应
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
    @JsonKey(name: 'expires_in') required int expiresIn,
    User? user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
