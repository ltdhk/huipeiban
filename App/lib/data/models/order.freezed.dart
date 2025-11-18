// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  @JsonKey(name: 'id')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_no')
  String? get orderNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_id')
  int? get patientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_type')
  String get orderType => throw _privateConstructorUsedError;
  @JsonKey(name: 'companion_id')
  int? get companionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'institution_id')
  int? get institutionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'hospital_name')
  String get hospitalName => throw _privateConstructorUsedError;
  @JsonKey(name: 'hospital_address')
  String? get hospitalAddress => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  @JsonKey(name: 'appointment_date', fromJson: _dateFromJson)
  DateTime? get appointmentDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'appointment_time')
  String get appointmentTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'need_pickup')
  bool get needPickup => throw _privateConstructorUsedError;
  @JsonKey(name: 'pickup_type')
  String? get pickupType => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_price', fromJson: _doubleFromJson)
  double get servicePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'pickup_price', fromJson: _doubleFromJson)
  double get pickupPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'coupon_discount', fromJson: _doubleFromJson)
  double get couponDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price', fromJson: _doubleFromJson)
  double get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_note')
  String? get userNote => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at', fromJson: _dateTimeFromJson)
  DateTime? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'accepted_at', fromJson: _dateTimeFromJson)
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_started_at', fromJson: _dateTimeFromJson)
  DateTime? get serviceStartedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_completed_at', fromJson: _dateTimeFromJson)
  DateTime? get serviceCompletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at', fromJson: _dateTimeFromJson)
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancel_reason')
  String? get cancelReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_by')
  String? get cancelledBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'refund_amount', fromJson: _doubleFromJsonNullable)
  double? get refundAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'refund_status')
  String? get refundStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError; // 关联数据
  Companion? get companion => throw _privateConstructorUsedError;
  Patient? get patient => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'order_no') String? orderNo,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'patient_id') int? patientId,
      @JsonKey(name: 'order_type') String orderType,
      @JsonKey(name: 'companion_id') int? companionId,
      @JsonKey(name: 'institution_id') int? institutionId,
      @JsonKey(name: 'hospital_name') String hospitalName,
      @JsonKey(name: 'hospital_address') String? hospitalAddress,
      String? department,
      @JsonKey(name: 'appointment_date', fromJson: _dateFromJson)
      DateTime? appointmentDate,
      @JsonKey(name: 'appointment_time') String appointmentTime,
      @JsonKey(name: 'need_pickup') bool needPickup,
      @JsonKey(name: 'pickup_type') String? pickupType,
      @JsonKey(name: 'service_price', fromJson: _doubleFromJson)
      double servicePrice,
      @JsonKey(name: 'pickup_price', fromJson: _doubleFromJson)
      double pickupPrice,
      @JsonKey(name: 'coupon_discount', fromJson: _doubleFromJson)
      double couponDiscount,
      @JsonKey(name: 'total_price', fromJson: _doubleFromJson)
      double totalPrice,
      @JsonKey(name: 'user_note') String? userNote,
      String status,
      @JsonKey(name: 'paid_at', fromJson: _dateTimeFromJson) DateTime? paidAt,
      @JsonKey(name: 'accepted_at', fromJson: _dateTimeFromJson)
      DateTime? acceptedAt,
      @JsonKey(name: 'service_started_at', fromJson: _dateTimeFromJson)
      DateTime? serviceStartedAt,
      @JsonKey(name: 'service_completed_at', fromJson: _dateTimeFromJson)
      DateTime? serviceCompletedAt,
      @JsonKey(name: 'cancelled_at', fromJson: _dateTimeFromJson)
      DateTime? cancelledAt,
      @JsonKey(name: 'cancel_reason') String? cancelReason,
      @JsonKey(name: 'cancelled_by') String? cancelledBy,
      @JsonKey(name: 'refund_amount', fromJson: _doubleFromJsonNullable)
      double? refundAmount,
      @JsonKey(name: 'refund_status') String? refundStatus,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt,
      Companion? companion,
      Patient? patient});

  $CompanionCopyWith<$Res>? get companion;
  $PatientCopyWith<$Res>? get patient;
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNo = freezed,
    Object? userId = freezed,
    Object? patientId = freezed,
    Object? orderType = null,
    Object? companionId = freezed,
    Object? institutionId = freezed,
    Object? hospitalName = null,
    Object? hospitalAddress = freezed,
    Object? department = freezed,
    Object? appointmentDate = freezed,
    Object? appointmentTime = null,
    Object? needPickup = null,
    Object? pickupType = freezed,
    Object? servicePrice = null,
    Object? pickupPrice = null,
    Object? couponDiscount = null,
    Object? totalPrice = null,
    Object? userNote = freezed,
    Object? status = null,
    Object? paidAt = freezed,
    Object? acceptedAt = freezed,
    Object? serviceStartedAt = freezed,
    Object? serviceCompletedAt = freezed,
    Object? cancelledAt = freezed,
    Object? cancelReason = freezed,
    Object? cancelledBy = freezed,
    Object? refundAmount = freezed,
    Object? refundStatus = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? companion = freezed,
    Object? patient = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderNo: freezed == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      patientId: freezed == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as int?,
      orderType: null == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      companionId: freezed == companionId
          ? _value.companionId
          : companionId // ignore: cast_nullable_to_non_nullable
              as int?,
      institutionId: freezed == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as int?,
      hospitalName: null == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String,
      hospitalAddress: freezed == hospitalAddress
          ? _value.hospitalAddress
          : hospitalAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      appointmentDate: freezed == appointmentDate
          ? _value.appointmentDate
          : appointmentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      appointmentTime: null == appointmentTime
          ? _value.appointmentTime
          : appointmentTime // ignore: cast_nullable_to_non_nullable
              as String,
      needPickup: null == needPickup
          ? _value.needPickup
          : needPickup // ignore: cast_nullable_to_non_nullable
              as bool,
      pickupType: freezed == pickupType
          ? _value.pickupType
          : pickupType // ignore: cast_nullable_to_non_nullable
              as String?,
      servicePrice: null == servicePrice
          ? _value.servicePrice
          : servicePrice // ignore: cast_nullable_to_non_nullable
              as double,
      pickupPrice: null == pickupPrice
          ? _value.pickupPrice
          : pickupPrice // ignore: cast_nullable_to_non_nullable
              as double,
      couponDiscount: null == couponDiscount
          ? _value.couponDiscount
          : couponDiscount // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      userNote: freezed == userNote
          ? _value.userNote
          : userNote // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceStartedAt: freezed == serviceStartedAt
          ? _value.serviceStartedAt
          : serviceStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceCompletedAt: freezed == serviceCompletedAt
          ? _value.serviceCompletedAt
          : serviceCompletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      refundAmount: freezed == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      refundStatus: freezed == refundStatus
          ? _value.refundStatus
          : refundStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companion: freezed == companion
          ? _value.companion
          : companion // ignore: cast_nullable_to_non_nullable
              as Companion?,
      patient: freezed == patient
          ? _value.patient
          : patient // ignore: cast_nullable_to_non_nullable
              as Patient?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CompanionCopyWith<$Res>? get companion {
    if (_value.companion == null) {
      return null;
    }

    return $CompanionCopyWith<$Res>(_value.companion!, (value) {
      return _then(_value.copyWith(companion: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PatientCopyWith<$Res>? get patient {
    if (_value.patient == null) {
      return null;
    }

    return $PatientCopyWith<$Res>(_value.patient!, (value) {
      return _then(_value.copyWith(patient: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
          _$OrderImpl value, $Res Function(_$OrderImpl) then) =
      __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'order_no') String? orderNo,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'patient_id') int? patientId,
      @JsonKey(name: 'order_type') String orderType,
      @JsonKey(name: 'companion_id') int? companionId,
      @JsonKey(name: 'institution_id') int? institutionId,
      @JsonKey(name: 'hospital_name') String hospitalName,
      @JsonKey(name: 'hospital_address') String? hospitalAddress,
      String? department,
      @JsonKey(name: 'appointment_date', fromJson: _dateFromJson)
      DateTime? appointmentDate,
      @JsonKey(name: 'appointment_time') String appointmentTime,
      @JsonKey(name: 'need_pickup') bool needPickup,
      @JsonKey(name: 'pickup_type') String? pickupType,
      @JsonKey(name: 'service_price', fromJson: _doubleFromJson)
      double servicePrice,
      @JsonKey(name: 'pickup_price', fromJson: _doubleFromJson)
      double pickupPrice,
      @JsonKey(name: 'coupon_discount', fromJson: _doubleFromJson)
      double couponDiscount,
      @JsonKey(name: 'total_price', fromJson: _doubleFromJson)
      double totalPrice,
      @JsonKey(name: 'user_note') String? userNote,
      String status,
      @JsonKey(name: 'paid_at', fromJson: _dateTimeFromJson) DateTime? paidAt,
      @JsonKey(name: 'accepted_at', fromJson: _dateTimeFromJson)
      DateTime? acceptedAt,
      @JsonKey(name: 'service_started_at', fromJson: _dateTimeFromJson)
      DateTime? serviceStartedAt,
      @JsonKey(name: 'service_completed_at', fromJson: _dateTimeFromJson)
      DateTime? serviceCompletedAt,
      @JsonKey(name: 'cancelled_at', fromJson: _dateTimeFromJson)
      DateTime? cancelledAt,
      @JsonKey(name: 'cancel_reason') String? cancelReason,
      @JsonKey(name: 'cancelled_by') String? cancelledBy,
      @JsonKey(name: 'refund_amount', fromJson: _doubleFromJsonNullable)
      double? refundAmount,
      @JsonKey(name: 'refund_status') String? refundStatus,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      DateTime? updatedAt,
      Companion? companion,
      Patient? patient});

  @override
  $CompanionCopyWith<$Res>? get companion;
  @override
  $PatientCopyWith<$Res>? get patient;
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
      _$OrderImpl _value, $Res Function(_$OrderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNo = freezed,
    Object? userId = freezed,
    Object? patientId = freezed,
    Object? orderType = null,
    Object? companionId = freezed,
    Object? institutionId = freezed,
    Object? hospitalName = null,
    Object? hospitalAddress = freezed,
    Object? department = freezed,
    Object? appointmentDate = freezed,
    Object? appointmentTime = null,
    Object? needPickup = null,
    Object? pickupType = freezed,
    Object? servicePrice = null,
    Object? pickupPrice = null,
    Object? couponDiscount = null,
    Object? totalPrice = null,
    Object? userNote = freezed,
    Object? status = null,
    Object? paidAt = freezed,
    Object? acceptedAt = freezed,
    Object? serviceStartedAt = freezed,
    Object? serviceCompletedAt = freezed,
    Object? cancelledAt = freezed,
    Object? cancelReason = freezed,
    Object? cancelledBy = freezed,
    Object? refundAmount = freezed,
    Object? refundStatus = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? companion = freezed,
    Object? patient = freezed,
  }) {
    return _then(_$OrderImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderNo: freezed == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      patientId: freezed == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as int?,
      orderType: null == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      companionId: freezed == companionId
          ? _value.companionId
          : companionId // ignore: cast_nullable_to_non_nullable
              as int?,
      institutionId: freezed == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as int?,
      hospitalName: null == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String,
      hospitalAddress: freezed == hospitalAddress
          ? _value.hospitalAddress
          : hospitalAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      appointmentDate: freezed == appointmentDate
          ? _value.appointmentDate
          : appointmentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      appointmentTime: null == appointmentTime
          ? _value.appointmentTime
          : appointmentTime // ignore: cast_nullable_to_non_nullable
              as String,
      needPickup: null == needPickup
          ? _value.needPickup
          : needPickup // ignore: cast_nullable_to_non_nullable
              as bool,
      pickupType: freezed == pickupType
          ? _value.pickupType
          : pickupType // ignore: cast_nullable_to_non_nullable
              as String?,
      servicePrice: null == servicePrice
          ? _value.servicePrice
          : servicePrice // ignore: cast_nullable_to_non_nullable
              as double,
      pickupPrice: null == pickupPrice
          ? _value.pickupPrice
          : pickupPrice // ignore: cast_nullable_to_non_nullable
              as double,
      couponDiscount: null == couponDiscount
          ? _value.couponDiscount
          : couponDiscount // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      userNote: freezed == userNote
          ? _value.userNote
          : userNote // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceStartedAt: freezed == serviceStartedAt
          ? _value.serviceStartedAt
          : serviceStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceCompletedAt: freezed == serviceCompletedAt
          ? _value.serviceCompletedAt
          : serviceCompletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      refundAmount: freezed == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      refundStatus: freezed == refundStatus
          ? _value.refundStatus
          : refundStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companion: freezed == companion
          ? _value.companion
          : companion // ignore: cast_nullable_to_non_nullable
              as Companion?,
      patient: freezed == patient
          ? _value.patient
          : patient // ignore: cast_nullable_to_non_nullable
              as Patient?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'order_no') this.orderNo,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'patient_id') this.patientId,
      @JsonKey(name: 'order_type') this.orderType = '',
      @JsonKey(name: 'companion_id') this.companionId,
      @JsonKey(name: 'institution_id') this.institutionId,
      @JsonKey(name: 'hospital_name') this.hospitalName = '',
      @JsonKey(name: 'hospital_address') this.hospitalAddress,
      this.department,
      @JsonKey(name: 'appointment_date', fromJson: _dateFromJson)
      this.appointmentDate,
      @JsonKey(name: 'appointment_time') this.appointmentTime = '',
      @JsonKey(name: 'need_pickup') this.needPickup = false,
      @JsonKey(name: 'pickup_type') this.pickupType,
      @JsonKey(name: 'service_price', fromJson: _doubleFromJson)
      this.servicePrice = 0.0,
      @JsonKey(name: 'pickup_price', fromJson: _doubleFromJson)
      this.pickupPrice = 0.0,
      @JsonKey(name: 'coupon_discount', fromJson: _doubleFromJson)
      this.couponDiscount = 0.0,
      @JsonKey(name: 'total_price', fromJson: _doubleFromJson)
      this.totalPrice = 0.0,
      @JsonKey(name: 'user_note') this.userNote,
      this.status = '',
      @JsonKey(name: 'paid_at', fromJson: _dateTimeFromJson) this.paidAt,
      @JsonKey(name: 'accepted_at', fromJson: _dateTimeFromJson)
      this.acceptedAt,
      @JsonKey(name: 'service_started_at', fromJson: _dateTimeFromJson)
      this.serviceStartedAt,
      @JsonKey(name: 'service_completed_at', fromJson: _dateTimeFromJson)
      this.serviceCompletedAt,
      @JsonKey(name: 'cancelled_at', fromJson: _dateTimeFromJson)
      this.cancelledAt,
      @JsonKey(name: 'cancel_reason') this.cancelReason,
      @JsonKey(name: 'cancelled_by') this.cancelledBy,
      @JsonKey(name: 'refund_amount', fromJson: _doubleFromJsonNullable)
      this.refundAmount,
      @JsonKey(name: 'refund_status') this.refundStatus,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt,
      this.companion,
      this.patient});

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'order_no')
  final String? orderNo;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'patient_id')
  final int? patientId;
  @override
  @JsonKey(name: 'order_type')
  final String orderType;
  @override
  @JsonKey(name: 'companion_id')
  final int? companionId;
  @override
  @JsonKey(name: 'institution_id')
  final int? institutionId;
  @override
  @JsonKey(name: 'hospital_name')
  final String hospitalName;
  @override
  @JsonKey(name: 'hospital_address')
  final String? hospitalAddress;
  @override
  final String? department;
  @override
  @JsonKey(name: 'appointment_date', fromJson: _dateFromJson)
  final DateTime? appointmentDate;
  @override
  @JsonKey(name: 'appointment_time')
  final String appointmentTime;
  @override
  @JsonKey(name: 'need_pickup')
  final bool needPickup;
  @override
  @JsonKey(name: 'pickup_type')
  final String? pickupType;
  @override
  @JsonKey(name: 'service_price', fromJson: _doubleFromJson)
  final double servicePrice;
  @override
  @JsonKey(name: 'pickup_price', fromJson: _doubleFromJson)
  final double pickupPrice;
  @override
  @JsonKey(name: 'coupon_discount', fromJson: _doubleFromJson)
  final double couponDiscount;
  @override
  @JsonKey(name: 'total_price', fromJson: _doubleFromJson)
  final double totalPrice;
  @override
  @JsonKey(name: 'user_note')
  final String? userNote;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'paid_at', fromJson: _dateTimeFromJson)
  final DateTime? paidAt;
  @override
  @JsonKey(name: 'accepted_at', fromJson: _dateTimeFromJson)
  final DateTime? acceptedAt;
  @override
  @JsonKey(name: 'service_started_at', fromJson: _dateTimeFromJson)
  final DateTime? serviceStartedAt;
  @override
  @JsonKey(name: 'service_completed_at', fromJson: _dateTimeFromJson)
  final DateTime? serviceCompletedAt;
  @override
  @JsonKey(name: 'cancelled_at', fromJson: _dateTimeFromJson)
  final DateTime? cancelledAt;
  @override
  @JsonKey(name: 'cancel_reason')
  final String? cancelReason;
  @override
  @JsonKey(name: 'cancelled_by')
  final String? cancelledBy;
  @override
  @JsonKey(name: 'refund_amount', fromJson: _doubleFromJsonNullable)
  final double? refundAmount;
  @override
  @JsonKey(name: 'refund_status')
  final String? refundStatus;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;
// 关联数据
  @override
  final Companion? companion;
  @override
  final Patient? patient;

  @override
  String toString() {
    return 'Order(id: $id, orderNo: $orderNo, userId: $userId, patientId: $patientId, orderType: $orderType, companionId: $companionId, institutionId: $institutionId, hospitalName: $hospitalName, hospitalAddress: $hospitalAddress, department: $department, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, needPickup: $needPickup, pickupType: $pickupType, servicePrice: $servicePrice, pickupPrice: $pickupPrice, couponDiscount: $couponDiscount, totalPrice: $totalPrice, userNote: $userNote, status: $status, paidAt: $paidAt, acceptedAt: $acceptedAt, serviceStartedAt: $serviceStartedAt, serviceCompletedAt: $serviceCompletedAt, cancelledAt: $cancelledAt, cancelReason: $cancelReason, cancelledBy: $cancelledBy, refundAmount: $refundAmount, refundStatus: $refundStatus, createdAt: $createdAt, updatedAt: $updatedAt, companion: $companion, patient: $patient)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.companionId, companionId) ||
                other.companionId == companionId) &&
            (identical(other.institutionId, institutionId) ||
                other.institutionId == institutionId) &&
            (identical(other.hospitalName, hospitalName) ||
                other.hospitalName == hospitalName) &&
            (identical(other.hospitalAddress, hospitalAddress) ||
                other.hospitalAddress == hospitalAddress) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.appointmentDate, appointmentDate) ||
                other.appointmentDate == appointmentDate) &&
            (identical(other.appointmentTime, appointmentTime) ||
                other.appointmentTime == appointmentTime) &&
            (identical(other.needPickup, needPickup) ||
                other.needPickup == needPickup) &&
            (identical(other.pickupType, pickupType) ||
                other.pickupType == pickupType) &&
            (identical(other.servicePrice, servicePrice) ||
                other.servicePrice == servicePrice) &&
            (identical(other.pickupPrice, pickupPrice) ||
                other.pickupPrice == pickupPrice) &&
            (identical(other.couponDiscount, couponDiscount) ||
                other.couponDiscount == couponDiscount) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.userNote, userNote) ||
                other.userNote == userNote) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.serviceStartedAt, serviceStartedAt) ||
                other.serviceStartedAt == serviceStartedAt) &&
            (identical(other.serviceCompletedAt, serviceCompletedAt) ||
                other.serviceCompletedAt == serviceCompletedAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason) &&
            (identical(other.cancelledBy, cancelledBy) ||
                other.cancelledBy == cancelledBy) &&
            (identical(other.refundAmount, refundAmount) ||
                other.refundAmount == refundAmount) &&
            (identical(other.refundStatus, refundStatus) ||
                other.refundStatus == refundStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.companion, companion) ||
                other.companion == companion) &&
            (identical(other.patient, patient) || other.patient == patient));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNo,
        userId,
        patientId,
        orderType,
        companionId,
        institutionId,
        hospitalName,
        hospitalAddress,
        department,
        appointmentDate,
        appointmentTime,
        needPickup,
        pickupType,
        servicePrice,
        pickupPrice,
        couponDiscount,
        totalPrice,
        userNote,
        status,
        paidAt,
        acceptedAt,
        serviceStartedAt,
        serviceCompletedAt,
        cancelledAt,
        cancelReason,
        cancelledBy,
        refundAmount,
        refundStatus,
        createdAt,
        updatedAt,
        companion,
        patient
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(
      this,
    );
  }
}

abstract class _Order implements Order {
  const factory _Order(
      {@JsonKey(name: 'id') final int? id,
      @JsonKey(name: 'order_no') final String? orderNo,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'patient_id') final int? patientId,
      @JsonKey(name: 'order_type') final String orderType,
      @JsonKey(name: 'companion_id') final int? companionId,
      @JsonKey(name: 'institution_id') final int? institutionId,
      @JsonKey(name: 'hospital_name') final String hospitalName,
      @JsonKey(name: 'hospital_address') final String? hospitalAddress,
      final String? department,
      @JsonKey(name: 'appointment_date', fromJson: _dateFromJson)
      final DateTime? appointmentDate,
      @JsonKey(name: 'appointment_time') final String appointmentTime,
      @JsonKey(name: 'need_pickup') final bool needPickup,
      @JsonKey(name: 'pickup_type') final String? pickupType,
      @JsonKey(name: 'service_price', fromJson: _doubleFromJson)
      final double servicePrice,
      @JsonKey(name: 'pickup_price', fromJson: _doubleFromJson)
      final double pickupPrice,
      @JsonKey(name: 'coupon_discount', fromJson: _doubleFromJson)
      final double couponDiscount,
      @JsonKey(name: 'total_price', fromJson: _doubleFromJson)
      final double totalPrice,
      @JsonKey(name: 'user_note') final String? userNote,
      final String status,
      @JsonKey(name: 'paid_at', fromJson: _dateTimeFromJson)
      final DateTime? paidAt,
      @JsonKey(name: 'accepted_at', fromJson: _dateTimeFromJson)
      final DateTime? acceptedAt,
      @JsonKey(name: 'service_started_at', fromJson: _dateTimeFromJson)
      final DateTime? serviceStartedAt,
      @JsonKey(name: 'service_completed_at', fromJson: _dateTimeFromJson)
      final DateTime? serviceCompletedAt,
      @JsonKey(name: 'cancelled_at', fromJson: _dateTimeFromJson)
      final DateTime? cancelledAt,
      @JsonKey(name: 'cancel_reason') final String? cancelReason,
      @JsonKey(name: 'cancelled_by') final String? cancelledBy,
      @JsonKey(name: 'refund_amount', fromJson: _doubleFromJsonNullable)
      final double? refundAmount,
      @JsonKey(name: 'refund_status') final String? refundStatus,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
      final DateTime? updatedAt,
      final Companion? companion,
      final Patient? patient}) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int? get id;
  @override
  @JsonKey(name: 'order_no')
  String? get orderNo;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'patient_id')
  int? get patientId;
  @override
  @JsonKey(name: 'order_type')
  String get orderType;
  @override
  @JsonKey(name: 'companion_id')
  int? get companionId;
  @override
  @JsonKey(name: 'institution_id')
  int? get institutionId;
  @override
  @JsonKey(name: 'hospital_name')
  String get hospitalName;
  @override
  @JsonKey(name: 'hospital_address')
  String? get hospitalAddress;
  @override
  String? get department;
  @override
  @JsonKey(name: 'appointment_date', fromJson: _dateFromJson)
  DateTime? get appointmentDate;
  @override
  @JsonKey(name: 'appointment_time')
  String get appointmentTime;
  @override
  @JsonKey(name: 'need_pickup')
  bool get needPickup;
  @override
  @JsonKey(name: 'pickup_type')
  String? get pickupType;
  @override
  @JsonKey(name: 'service_price', fromJson: _doubleFromJson)
  double get servicePrice;
  @override
  @JsonKey(name: 'pickup_price', fromJson: _doubleFromJson)
  double get pickupPrice;
  @override
  @JsonKey(name: 'coupon_discount', fromJson: _doubleFromJson)
  double get couponDiscount;
  @override
  @JsonKey(name: 'total_price', fromJson: _doubleFromJson)
  double get totalPrice;
  @override
  @JsonKey(name: 'user_note')
  String? get userNote;
  @override
  String get status;
  @override
  @JsonKey(name: 'paid_at', fromJson: _dateTimeFromJson)
  DateTime? get paidAt;
  @override
  @JsonKey(name: 'accepted_at', fromJson: _dateTimeFromJson)
  DateTime? get acceptedAt;
  @override
  @JsonKey(name: 'service_started_at', fromJson: _dateTimeFromJson)
  DateTime? get serviceStartedAt;
  @override
  @JsonKey(name: 'service_completed_at', fromJson: _dateTimeFromJson)
  DateTime? get serviceCompletedAt;
  @override
  @JsonKey(name: 'cancelled_at', fromJson: _dateTimeFromJson)
  DateTime? get cancelledAt;
  @override
  @JsonKey(name: 'cancel_reason')
  String? get cancelReason;
  @override
  @JsonKey(name: 'cancelled_by')
  String? get cancelledBy;
  @override
  @JsonKey(name: 'refund_amount', fromJson: _doubleFromJsonNullable)
  double? get refundAmount;
  @override
  @JsonKey(name: 'refund_status')
  String? get refundStatus;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;
  @override // 关联数据
  Companion? get companion;
  @override
  Patient? get patient;
  @override
  @JsonKey(ignore: true)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) {
  return _CreateOrderRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateOrderRequest {
  @JsonKey(name: 'patient_id')
  int get patientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_type')
  String get orderType => throw _privateConstructorUsedError;
  @JsonKey(name: 'companion_id')
  int? get companionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'institution_id')
  int? get institutionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'hospital_name')
  String get hospitalName => throw _privateConstructorUsedError;
  @JsonKey(name: 'hospital_address')
  String? get hospitalAddress => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  @JsonKey(name: 'appointment_date')
  String get appointmentDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'appointment_time')
  String get appointmentTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'need_pickup')
  bool get needPickup => throw _privateConstructorUsedError;
  @JsonKey(name: 'pickup_type')
  String? get pickupType => throw _privateConstructorUsedError;
  @JsonKey(name: 'pickup_address_id')
  int? get pickupAddressId => throw _privateConstructorUsedError;
  @JsonKey(name: 'dropoff_address_id')
  int? get dropoffAddressId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_package')
  String? get servicePackage => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_note')
  String? get userNote => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateOrderRequestCopyWith<CreateOrderRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrderRequestCopyWith<$Res> {
  factory $CreateOrderRequestCopyWith(
          CreateOrderRequest value, $Res Function(CreateOrderRequest) then) =
      _$CreateOrderRequestCopyWithImpl<$Res, CreateOrderRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'patient_id') int patientId,
      @JsonKey(name: 'order_type') String orderType,
      @JsonKey(name: 'companion_id') int? companionId,
      @JsonKey(name: 'institution_id') int? institutionId,
      @JsonKey(name: 'hospital_name') String hospitalName,
      @JsonKey(name: 'hospital_address') String? hospitalAddress,
      String? department,
      @JsonKey(name: 'appointment_date') String appointmentDate,
      @JsonKey(name: 'appointment_time') String appointmentTime,
      @JsonKey(name: 'need_pickup') bool needPickup,
      @JsonKey(name: 'pickup_type') String? pickupType,
      @JsonKey(name: 'pickup_address_id') int? pickupAddressId,
      @JsonKey(name: 'dropoff_address_id') int? dropoffAddressId,
      @JsonKey(name: 'service_package') String? servicePackage,
      @JsonKey(name: 'user_note') String? userNote});
}

/// @nodoc
class _$CreateOrderRequestCopyWithImpl<$Res, $Val extends CreateOrderRequest>
    implements $CreateOrderRequestCopyWith<$Res> {
  _$CreateOrderRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patientId = null,
    Object? orderType = null,
    Object? companionId = freezed,
    Object? institutionId = freezed,
    Object? hospitalName = null,
    Object? hospitalAddress = freezed,
    Object? department = freezed,
    Object? appointmentDate = null,
    Object? appointmentTime = null,
    Object? needPickup = null,
    Object? pickupType = freezed,
    Object? pickupAddressId = freezed,
    Object? dropoffAddressId = freezed,
    Object? servicePackage = freezed,
    Object? userNote = freezed,
  }) {
    return _then(_value.copyWith(
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as int,
      orderType: null == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      companionId: freezed == companionId
          ? _value.companionId
          : companionId // ignore: cast_nullable_to_non_nullable
              as int?,
      institutionId: freezed == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as int?,
      hospitalName: null == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String,
      hospitalAddress: freezed == hospitalAddress
          ? _value.hospitalAddress
          : hospitalAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      appointmentDate: null == appointmentDate
          ? _value.appointmentDate
          : appointmentDate // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentTime: null == appointmentTime
          ? _value.appointmentTime
          : appointmentTime // ignore: cast_nullable_to_non_nullable
              as String,
      needPickup: null == needPickup
          ? _value.needPickup
          : needPickup // ignore: cast_nullable_to_non_nullable
              as bool,
      pickupType: freezed == pickupType
          ? _value.pickupType
          : pickupType // ignore: cast_nullable_to_non_nullable
              as String?,
      pickupAddressId: freezed == pickupAddressId
          ? _value.pickupAddressId
          : pickupAddressId // ignore: cast_nullable_to_non_nullable
              as int?,
      dropoffAddressId: freezed == dropoffAddressId
          ? _value.dropoffAddressId
          : dropoffAddressId // ignore: cast_nullable_to_non_nullable
              as int?,
      servicePackage: freezed == servicePackage
          ? _value.servicePackage
          : servicePackage // ignore: cast_nullable_to_non_nullable
              as String?,
      userNote: freezed == userNote
          ? _value.userNote
          : userNote // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateOrderRequestImplCopyWith<$Res>
    implements $CreateOrderRequestCopyWith<$Res> {
  factory _$$CreateOrderRequestImplCopyWith(_$CreateOrderRequestImpl value,
          $Res Function(_$CreateOrderRequestImpl) then) =
      __$$CreateOrderRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'patient_id') int patientId,
      @JsonKey(name: 'order_type') String orderType,
      @JsonKey(name: 'companion_id') int? companionId,
      @JsonKey(name: 'institution_id') int? institutionId,
      @JsonKey(name: 'hospital_name') String hospitalName,
      @JsonKey(name: 'hospital_address') String? hospitalAddress,
      String? department,
      @JsonKey(name: 'appointment_date') String appointmentDate,
      @JsonKey(name: 'appointment_time') String appointmentTime,
      @JsonKey(name: 'need_pickup') bool needPickup,
      @JsonKey(name: 'pickup_type') String? pickupType,
      @JsonKey(name: 'pickup_address_id') int? pickupAddressId,
      @JsonKey(name: 'dropoff_address_id') int? dropoffAddressId,
      @JsonKey(name: 'service_package') String? servicePackage,
      @JsonKey(name: 'user_note') String? userNote});
}

/// @nodoc
class __$$CreateOrderRequestImplCopyWithImpl<$Res>
    extends _$CreateOrderRequestCopyWithImpl<$Res, _$CreateOrderRequestImpl>
    implements _$$CreateOrderRequestImplCopyWith<$Res> {
  __$$CreateOrderRequestImplCopyWithImpl(_$CreateOrderRequestImpl _value,
      $Res Function(_$CreateOrderRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patientId = null,
    Object? orderType = null,
    Object? companionId = freezed,
    Object? institutionId = freezed,
    Object? hospitalName = null,
    Object? hospitalAddress = freezed,
    Object? department = freezed,
    Object? appointmentDate = null,
    Object? appointmentTime = null,
    Object? needPickup = null,
    Object? pickupType = freezed,
    Object? pickupAddressId = freezed,
    Object? dropoffAddressId = freezed,
    Object? servicePackage = freezed,
    Object? userNote = freezed,
  }) {
    return _then(_$CreateOrderRequestImpl(
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as int,
      orderType: null == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      companionId: freezed == companionId
          ? _value.companionId
          : companionId // ignore: cast_nullable_to_non_nullable
              as int?,
      institutionId: freezed == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as int?,
      hospitalName: null == hospitalName
          ? _value.hospitalName
          : hospitalName // ignore: cast_nullable_to_non_nullable
              as String,
      hospitalAddress: freezed == hospitalAddress
          ? _value.hospitalAddress
          : hospitalAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      appointmentDate: null == appointmentDate
          ? _value.appointmentDate
          : appointmentDate // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentTime: null == appointmentTime
          ? _value.appointmentTime
          : appointmentTime // ignore: cast_nullable_to_non_nullable
              as String,
      needPickup: null == needPickup
          ? _value.needPickup
          : needPickup // ignore: cast_nullable_to_non_nullable
              as bool,
      pickupType: freezed == pickupType
          ? _value.pickupType
          : pickupType // ignore: cast_nullable_to_non_nullable
              as String?,
      pickupAddressId: freezed == pickupAddressId
          ? _value.pickupAddressId
          : pickupAddressId // ignore: cast_nullable_to_non_nullable
              as int?,
      dropoffAddressId: freezed == dropoffAddressId
          ? _value.dropoffAddressId
          : dropoffAddressId // ignore: cast_nullable_to_non_nullable
              as int?,
      servicePackage: freezed == servicePackage
          ? _value.servicePackage
          : servicePackage // ignore: cast_nullable_to_non_nullable
              as String?,
      userNote: freezed == userNote
          ? _value.userNote
          : userNote // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateOrderRequestImpl implements _CreateOrderRequest {
  const _$CreateOrderRequestImpl(
      {@JsonKey(name: 'patient_id') required this.patientId,
      @JsonKey(name: 'order_type') required this.orderType,
      @JsonKey(name: 'companion_id') this.companionId,
      @JsonKey(name: 'institution_id') this.institutionId,
      @JsonKey(name: 'hospital_name') required this.hospitalName,
      @JsonKey(name: 'hospital_address') this.hospitalAddress,
      this.department,
      @JsonKey(name: 'appointment_date') required this.appointmentDate,
      @JsonKey(name: 'appointment_time') required this.appointmentTime,
      @JsonKey(name: 'need_pickup') this.needPickup = false,
      @JsonKey(name: 'pickup_type') this.pickupType,
      @JsonKey(name: 'pickup_address_id') this.pickupAddressId,
      @JsonKey(name: 'dropoff_address_id') this.dropoffAddressId,
      @JsonKey(name: 'service_package') this.servicePackage,
      @JsonKey(name: 'user_note') this.userNote});

  factory _$CreateOrderRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateOrderRequestImplFromJson(json);

  @override
  @JsonKey(name: 'patient_id')
  final int patientId;
  @override
  @JsonKey(name: 'order_type')
  final String orderType;
  @override
  @JsonKey(name: 'companion_id')
  final int? companionId;
  @override
  @JsonKey(name: 'institution_id')
  final int? institutionId;
  @override
  @JsonKey(name: 'hospital_name')
  final String hospitalName;
  @override
  @JsonKey(name: 'hospital_address')
  final String? hospitalAddress;
  @override
  final String? department;
  @override
  @JsonKey(name: 'appointment_date')
  final String appointmentDate;
  @override
  @JsonKey(name: 'appointment_time')
  final String appointmentTime;
  @override
  @JsonKey(name: 'need_pickup')
  final bool needPickup;
  @override
  @JsonKey(name: 'pickup_type')
  final String? pickupType;
  @override
  @JsonKey(name: 'pickup_address_id')
  final int? pickupAddressId;
  @override
  @JsonKey(name: 'dropoff_address_id')
  final int? dropoffAddressId;
  @override
  @JsonKey(name: 'service_package')
  final String? servicePackage;
  @override
  @JsonKey(name: 'user_note')
  final String? userNote;

  @override
  String toString() {
    return 'CreateOrderRequest(patientId: $patientId, orderType: $orderType, companionId: $companionId, institutionId: $institutionId, hospitalName: $hospitalName, hospitalAddress: $hospitalAddress, department: $department, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, needPickup: $needPickup, pickupType: $pickupType, pickupAddressId: $pickupAddressId, dropoffAddressId: $dropoffAddressId, servicePackage: $servicePackage, userNote: $userNote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrderRequestImpl &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.companionId, companionId) ||
                other.companionId == companionId) &&
            (identical(other.institutionId, institutionId) ||
                other.institutionId == institutionId) &&
            (identical(other.hospitalName, hospitalName) ||
                other.hospitalName == hospitalName) &&
            (identical(other.hospitalAddress, hospitalAddress) ||
                other.hospitalAddress == hospitalAddress) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.appointmentDate, appointmentDate) ||
                other.appointmentDate == appointmentDate) &&
            (identical(other.appointmentTime, appointmentTime) ||
                other.appointmentTime == appointmentTime) &&
            (identical(other.needPickup, needPickup) ||
                other.needPickup == needPickup) &&
            (identical(other.pickupType, pickupType) ||
                other.pickupType == pickupType) &&
            (identical(other.pickupAddressId, pickupAddressId) ||
                other.pickupAddressId == pickupAddressId) &&
            (identical(other.dropoffAddressId, dropoffAddressId) ||
                other.dropoffAddressId == dropoffAddressId) &&
            (identical(other.servicePackage, servicePackage) ||
                other.servicePackage == servicePackage) &&
            (identical(other.userNote, userNote) ||
                other.userNote == userNote));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      patientId,
      orderType,
      companionId,
      institutionId,
      hospitalName,
      hospitalAddress,
      department,
      appointmentDate,
      appointmentTime,
      needPickup,
      pickupType,
      pickupAddressId,
      dropoffAddressId,
      servicePackage,
      userNote);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrderRequestImplCopyWith<_$CreateOrderRequestImpl> get copyWith =>
      __$$CreateOrderRequestImplCopyWithImpl<_$CreateOrderRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrderRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateOrderRequest implements CreateOrderRequest {
  const factory _CreateOrderRequest(
      {@JsonKey(name: 'patient_id') required final int patientId,
      @JsonKey(name: 'order_type') required final String orderType,
      @JsonKey(name: 'companion_id') final int? companionId,
      @JsonKey(name: 'institution_id') final int? institutionId,
      @JsonKey(name: 'hospital_name') required final String hospitalName,
      @JsonKey(name: 'hospital_address') final String? hospitalAddress,
      final String? department,
      @JsonKey(name: 'appointment_date') required final String appointmentDate,
      @JsonKey(name: 'appointment_time') required final String appointmentTime,
      @JsonKey(name: 'need_pickup') final bool needPickup,
      @JsonKey(name: 'pickup_type') final String? pickupType,
      @JsonKey(name: 'pickup_address_id') final int? pickupAddressId,
      @JsonKey(name: 'dropoff_address_id') final int? dropoffAddressId,
      @JsonKey(name: 'service_package') final String? servicePackage,
      @JsonKey(name: 'user_note')
      final String? userNote}) = _$CreateOrderRequestImpl;

  factory _CreateOrderRequest.fromJson(Map<String, dynamic> json) =
      _$CreateOrderRequestImpl.fromJson;

  @override
  @JsonKey(name: 'patient_id')
  int get patientId;
  @override
  @JsonKey(name: 'order_type')
  String get orderType;
  @override
  @JsonKey(name: 'companion_id')
  int? get companionId;
  @override
  @JsonKey(name: 'institution_id')
  int? get institutionId;
  @override
  @JsonKey(name: 'hospital_name')
  String get hospitalName;
  @override
  @JsonKey(name: 'hospital_address')
  String? get hospitalAddress;
  @override
  String? get department;
  @override
  @JsonKey(name: 'appointment_date')
  String get appointmentDate;
  @override
  @JsonKey(name: 'appointment_time')
  String get appointmentTime;
  @override
  @JsonKey(name: 'need_pickup')
  bool get needPickup;
  @override
  @JsonKey(name: 'pickup_type')
  String? get pickupType;
  @override
  @JsonKey(name: 'pickup_address_id')
  int? get pickupAddressId;
  @override
  @JsonKey(name: 'dropoff_address_id')
  int? get dropoffAddressId;
  @override
  @JsonKey(name: 'service_package')
  String? get servicePackage;
  @override
  @JsonKey(name: 'user_note')
  String? get userNote;
  @override
  @JsonKey(ignore: true)
  _$$CreateOrderRequestImplCopyWith<_$CreateOrderRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
