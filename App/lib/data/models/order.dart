import 'package:freezed_annotation/freezed_annotation.dart';
import 'companion.dart';
import 'institution.dart';
import 'patient.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// 订单模型
@freezed
class Order with _$Order {
  const factory Order({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'order_no') String? orderNo,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'patient_id') int? patientId,
    @JsonKey(name: 'order_type') @Default('') String orderType,
    @JsonKey(name: 'companion_id') int? companionId,
    @JsonKey(name: 'institution_id') int? institutionId,
    @JsonKey(name: 'hospital_name') @Default('') String hospitalName,
    @JsonKey(name: 'hospital_address') String? hospitalAddress,
    String? department,
    @JsonKey(name: 'appointment_date', fromJson: _dateFromJson) DateTime? appointmentDate,
    @JsonKey(name: 'appointment_time') @Default('') String appointmentTime,
    @JsonKey(name: 'need_pickup') @Default(false) bool needPickup,
    @JsonKey(name: 'pickup_type') String? pickupType,
    @JsonKey(name: 'service_price', fromJson: _doubleFromJson) @Default(0.0) double servicePrice,
    @JsonKey(name: 'pickup_price', fromJson: _doubleFromJson) @Default(0.0) double pickupPrice,
    @JsonKey(name: 'coupon_discount', fromJson: _doubleFromJson) @Default(0.0) double couponDiscount,
    @JsonKey(name: 'total_price', fromJson: _doubleFromJson) @Default(0.0) double totalPrice,
    @JsonKey(name: 'user_note') String? userNote,
    @Default('') String status,
    @JsonKey(name: 'paid_at', fromJson: _dateTimeFromJson) DateTime? paidAt,
    @JsonKey(name: 'accepted_at', fromJson: _dateTimeFromJson) DateTime? acceptedAt,
    @JsonKey(name: 'service_started_at', fromJson: _dateTimeFromJson) DateTime? serviceStartedAt,
    @JsonKey(name: 'service_completed_at', fromJson: _dateTimeFromJson) DateTime? serviceCompletedAt,
    @JsonKey(name: 'cancelled_at', fromJson: _dateTimeFromJson) DateTime? cancelledAt,
    @JsonKey(name: 'cancel_reason') String? cancelReason,
    @JsonKey(name: 'cancelled_by') String? cancelledBy,
    @JsonKey(name: 'refund_amount', fromJson: _doubleFromJsonNullable) double? refundAmount,
    @JsonKey(name: 'refund_status') String? refundStatus,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) DateTime? updatedAt,
    // 关联数据
    Companion? companion,
    Institution? institution,
    Patient? patient,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

// 自定义 JSON 转换函数
DateTime? _dateTimeFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (e) {
      return null;
    }
  }
  return null;
}

DateTime? _dateFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    try {
      // 处理日期格式 "YYYY-MM-DD"
      return DateTime.parse(value);
    } catch (e) {
      return null;
    }
  }
  return null;
}

double _doubleFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }
  return 0.0;
}

double? _doubleFromJsonNullable(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }
  return null;
}

/// 创建订单请求
@freezed
class CreateOrderRequest with _$CreateOrderRequest {
  const factory CreateOrderRequest({
    @JsonKey(name: 'patient_id') required int patientId,
    @JsonKey(name: 'order_type') required String orderType,
    @JsonKey(name: 'companion_id') int? companionId,
    @JsonKey(name: 'institution_id') int? institutionId,
    @JsonKey(name: 'hospital_name') required String hospitalName,
    @JsonKey(name: 'hospital_address') String? hospitalAddress,
    String? department,
    @JsonKey(name: 'appointment_date') required String appointmentDate,
    @JsonKey(name: 'appointment_time') required String appointmentTime,
    @JsonKey(name: 'need_pickup') @Default(false) bool needPickup,
    @JsonKey(name: 'pickup_type') String? pickupType,
    @JsonKey(name: 'pickup_address_id') int? pickupAddressId,
    @JsonKey(name: 'dropoff_address_id') int? dropoffAddressId,
    @JsonKey(name: 'service_package') String? servicePackage,
    @JsonKey(name: 'user_note') String? userNote,
  }) = _CreateOrderRequest;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);
}
