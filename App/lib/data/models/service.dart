import 'package:freezed_annotation/freezed_annotation.dart';

part 'service.freezed.dart';
part 'service.g.dart';

/// 服务套餐模型
@freezed
class Service with _$Service {
  const factory Service({
    required int id,
    @JsonKey(name: 'companion_id') required int companionId,
    required String title,
    String? category,
    String? description,
    List<String>? features,
    @JsonKey(name: 'base_price') required double basePrice,
    @JsonKey(name: 'additional_hour_price') double? additionalHourPrice,
    @JsonKey(name: 'sales_count') @Default(0) int salesCount,
    @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // 服务规格列表
    List<ServiceSpec>? specs,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
}

/// 服务规格模型
@freezed
class ServiceSpec with _$ServiceSpec {
  const factory ServiceSpec({
    required int id,
    @JsonKey(name: 'service_id') required int serviceId,
    required String name,
    String? description,
    @JsonKey(name: 'duration_hours') required int durationHours,
    required double price,
    List<String>? features,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ServiceSpec;

  factory ServiceSpec.fromJson(Map<String, dynamic> json) =>
      _$ServiceSpecFromJson(json);
}
