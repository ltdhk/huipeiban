// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: (json['id'] as num?)?.toInt(),
      orderNo: json['order_no'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      patientId: (json['patient_id'] as num?)?.toInt(),
      orderType: json['order_type'] as String? ?? '',
      companionId: (json['companion_id'] as num?)?.toInt(),
      institutionId: (json['institution_id'] as num?)?.toInt(),
      hospitalName: json['hospital_name'] as String? ?? '',
      hospitalAddress: json['hospital_address'] as String?,
      department: json['department'] as String?,
      appointmentDate: _dateFromJson(json['appointment_date']),
      appointmentTime: json['appointment_time'] as String? ?? '',
      needPickup: json['need_pickup'] as bool? ?? false,
      pickupType: json['pickup_type'] as String?,
      servicePrice: json['service_price'] == null
          ? 0.0
          : _doubleFromJson(json['service_price']),
      pickupPrice: json['pickup_price'] == null
          ? 0.0
          : _doubleFromJson(json['pickup_price']),
      couponDiscount: json['coupon_discount'] == null
          ? 0.0
          : _doubleFromJson(json['coupon_discount']),
      totalPrice: json['total_price'] == null
          ? 0.0
          : _doubleFromJson(json['total_price']),
      userNote: json['user_note'] as String?,
      status: json['status'] as String? ?? '',
      paidAt: _dateTimeFromJson(json['paid_at']),
      acceptedAt: _dateTimeFromJson(json['accepted_at']),
      serviceStartedAt: _dateTimeFromJson(json['service_started_at']),
      serviceCompletedAt: _dateTimeFromJson(json['service_completed_at']),
      cancelledAt: _dateTimeFromJson(json['cancelled_at']),
      cancelReason: json['cancel_reason'] as String?,
      cancelledBy: json['cancelled_by'] as String?,
      refundAmount: _doubleFromJsonNullable(json['refund_amount']),
      refundStatus: json['refund_status'] as String?,
      createdAt: _dateTimeFromJson(json['created_at']),
      updatedAt: _dateTimeFromJson(json['updated_at']),
      companion: json['companion'] == null
          ? null
          : Companion.fromJson(json['companion'] as Map<String, dynamic>),
      institution: json['institution'] == null
          ? null
          : Institution.fromJson(json['institution'] as Map<String, dynamic>),
      patient: json['patient'] == null
          ? null
          : Patient.fromJson(json['patient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_no': instance.orderNo,
      'user_id': instance.userId,
      'patient_id': instance.patientId,
      'order_type': instance.orderType,
      'companion_id': instance.companionId,
      'institution_id': instance.institutionId,
      'hospital_name': instance.hospitalName,
      'hospital_address': instance.hospitalAddress,
      'department': instance.department,
      'appointment_date': instance.appointmentDate?.toIso8601String(),
      'appointment_time': instance.appointmentTime,
      'need_pickup': instance.needPickup,
      'pickup_type': instance.pickupType,
      'service_price': instance.servicePrice,
      'pickup_price': instance.pickupPrice,
      'coupon_discount': instance.couponDiscount,
      'total_price': instance.totalPrice,
      'user_note': instance.userNote,
      'status': instance.status,
      'paid_at': instance.paidAt?.toIso8601String(),
      'accepted_at': instance.acceptedAt?.toIso8601String(),
      'service_started_at': instance.serviceStartedAt?.toIso8601String(),
      'service_completed_at': instance.serviceCompletedAt?.toIso8601String(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'cancel_reason': instance.cancelReason,
      'cancelled_by': instance.cancelledBy,
      'refund_amount': instance.refundAmount,
      'refund_status': instance.refundStatus,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'companion': instance.companion,
      'institution': instance.institution,
      'patient': instance.patient,
    };

_$CreateOrderRequestImpl _$$CreateOrderRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateOrderRequestImpl(
      patientId: (json['patient_id'] as num).toInt(),
      orderType: json['order_type'] as String,
      companionId: (json['companion_id'] as num?)?.toInt(),
      institutionId: (json['institution_id'] as num?)?.toInt(),
      hospitalName: json['hospital_name'] as String,
      hospitalAddress: json['hospital_address'] as String?,
      department: json['department'] as String?,
      appointmentDate: json['appointment_date'] as String,
      appointmentTime: json['appointment_time'] as String,
      needPickup: json['need_pickup'] as bool? ?? false,
      pickupType: json['pickup_type'] as String?,
      pickupAddressId: (json['pickup_address_id'] as num?)?.toInt(),
      dropoffAddressId: (json['dropoff_address_id'] as num?)?.toInt(),
      servicePackage: json['service_package'] as String?,
      userNote: json['user_note'] as String?,
    );

Map<String, dynamic> _$$CreateOrderRequestImplToJson(
        _$CreateOrderRequestImpl instance) =>
    <String, dynamic>{
      'patient_id': instance.patientId,
      'order_type': instance.orderType,
      'companion_id': instance.companionId,
      'institution_id': instance.institutionId,
      'hospital_name': instance.hospitalName,
      'hospital_address': instance.hospitalAddress,
      'department': instance.department,
      'appointment_date': instance.appointmentDate,
      'appointment_time': instance.appointmentTime,
      'need_pickup': instance.needPickup,
      'pickup_type': instance.pickupType,
      'pickup_address_id': instance.pickupAddressId,
      'dropoff_address_id': instance.dropoffAddressId,
      'service_package': instance.servicePackage,
      'user_note': instance.userNote,
    };
