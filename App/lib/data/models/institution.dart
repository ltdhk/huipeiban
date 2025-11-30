import 'package:freezed_annotation/freezed_annotation.dart';

part 'institution.freezed.dart';
part 'institution.g.dart';

// 自定义 JSON 转换函数
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

/// 陪诊机构模型
@freezed
class Institution with _$Institution {
  const factory Institution({
    @JsonKey(fromJson: _intFromJson) @Default(0) int id,
    /// 关联的用户ID（用于即时通讯）
    @JsonKey(name: 'user_id') int? userId,
    @Default('') String name,
    @JsonKey(name: 'logo_url') String? logoUrl,
    String? description,
    String? address,
    String? phone,
    String? city,
    @JsonKey(name: 'business_license') String? businessLicense,
    @JsonKey(fromJson: _doubleFromJson) @Default(5.0) double rating,
    @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    @JsonKey(name: 'total_orders') @Default(0) int totalOrders,
    @JsonKey(name: 'completed_orders') @Default(0) int completedOrders,
    @JsonKey(name: 'companion_count') @Default(0) int companionCount,
    @Default('approved') String status,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'service_hospitals') List<String>? serviceHospitals,
    @JsonKey(name: 'service_area') List<String>? serviceArea,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Institution;

  factory Institution.fromJson(Map<String, dynamic> json) =>
      _$InstitutionFromJson(json);
}

/// 机构推荐响应 (从 AI 返回)
@freezed
class InstitutionRecommendation with _$InstitutionRecommendation {
  const factory InstitutionRecommendation({
    required Institution institution,
    @JsonKey(name: 'match_score') double? matchScore,
    String? reason,
  }) = _InstitutionRecommendation;

  factory InstitutionRecommendation.fromJson(Map<String, dynamic> json) =>
      _$InstitutionRecommendationFromJson(json);
}
