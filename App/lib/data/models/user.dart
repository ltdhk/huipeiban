import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 用户模型
@freezed
class User with _$User {
  const factory User({
    required int id,
    String? phone,
    String? nickname,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? gender,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
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
