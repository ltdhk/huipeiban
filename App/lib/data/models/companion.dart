import 'package:freezed_annotation/freezed_annotation.dart';

part 'companion.freezed.dart';
part 'companion.g.dart';

// 自定义 JSON 转换函数
double _doubleFromJson(dynamic value) {
  if (value == null) return 5.0;
  if (value is num) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      return 5.0;
    }
  }
  return 5.0;
}

int _intFromJson(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  if (value is String) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  }
  return 0;
}

int? _intFromJsonNullable(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) {
    try {
      return int.parse(value);
    } catch (e) {
      return null;
    }
  }
  return null;
}

/// 陪诊师模型
@freezed
class Companion with _$Companion {
  const factory Companion({
    @Default(0) int id,
    /// 关联的用户ID（用于即时通讯）
    @JsonKey(name: 'user_id') int? userId,
    @Default('') String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? gender,
    int? age,
    @JsonKey(name: 'institution_id') int? institutionId,
    @JsonKey(name: 'service_years') int? serviceYears,
    String? introduction,
    @JsonKey(name: 'has_car') @Default(false) bool hasCar,
    @JsonKey(name: 'car_type') String? carType,
    @JsonKey(fromJson: _doubleFromJson) @Default(5.0) double rating,
    @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    @JsonKey(name: 'total_orders') @Default(0) int totalOrders,
    @JsonKey(name: 'completed_orders') @Default(0) int completedOrders,
    @Default('approved') String status,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    @JsonKey(name: 'service_hospitals') List<String>? serviceHospitals,
    @JsonKey(name: 'service_area') List<String>? serviceArea,
    @JsonKey(name: 'specialties') List<String>? specialties,
    @JsonKey(name: 'certificates') List<String>? certificates,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Companion;

  factory Companion.fromJson(Map<String, dynamic> json) =>
      _$CompanionFromJson(json);
}

/// 陪诊师推荐响应 (从 AI 返回)
@freezed
class CompanionRecommendation with _$CompanionRecommendation {
  const factory CompanionRecommendation({
    required Companion companion,
    @JsonKey(name: 'match_score') double? matchScore,
    String? reason,
  }) = _CompanionRecommendation;

  factory CompanionRecommendation.fromJson(Map<String, dynamic> json) =>
      _$CompanionRecommendationFromJson(json);
}
