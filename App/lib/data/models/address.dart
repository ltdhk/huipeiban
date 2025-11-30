import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

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

/// 地址模型
@freezed
class Address with _$Address {
  const factory Address({
    @JsonKey(fromJson: _intFromJson) @Default(0) int id,
    @JsonKey(name: 'user_id', fromJson: _intFromJson) @Default(0) int userId,
    @JsonKey(name: 'contact_name') @Default('') String contactName,
    @JsonKey(name: 'contact_phone') @Default('') String contactPhone,
    @Default('') String province,
    @Default('') String city,
    @Default('') String district,
    @JsonKey(name: 'detail_address') @Default('') String detailAddress,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'address_type') @Default('other') String addressType,
    String? label,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

/// 创建地址请求
@freezed
class CreateAddressRequest with _$CreateAddressRequest {
  const factory CreateAddressRequest({
    @JsonKey(name: 'contact_name') required String contactName,
    @JsonKey(name: 'contact_phone') required String contactPhone,
    required String province,
    required String city,
    required String district,
    @JsonKey(name: 'detail_address') required String detailAddress,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'address_type') String? addressType,
    String? label,
  }) = _CreateAddressRequest;

  factory CreateAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAddressRequestFromJson(json);
}
