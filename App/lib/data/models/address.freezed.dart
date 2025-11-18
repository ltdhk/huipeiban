// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Address _$AddressFromJson(Map<String, dynamic> json) {
  return _Address.fromJson(json);
}

/// @nodoc
mixin _$Address {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_name')
  String get contactName => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_phone')
  String get contactPhone => throw _privateConstructorUsedError;
  String get province => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get district => throw _privateConstructorUsedError;
  @JsonKey(name: 'detail_address')
  String get detailAddress => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_type')
  String get addressType => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddressCopyWith<Address> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressCopyWith<$Res> {
  factory $AddressCopyWith(Address value, $Res Function(Address) then) =
      _$AddressCopyWithImpl<$Res, Address>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'contact_name') String contactName,
      @JsonKey(name: 'contact_phone') String contactPhone,
      String province,
      String city,
      String district,
      @JsonKey(name: 'detail_address') String detailAddress,
      double? latitude,
      double? longitude,
      @JsonKey(name: 'address_type') String addressType,
      String? label,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$AddressCopyWithImpl<$Res, $Val extends Address>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? contactName = null,
    Object? contactPhone = null,
    Object? province = null,
    Object? city = null,
    Object? district = null,
    Object? detailAddress = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? addressType = null,
    Object? label = freezed,
    Object? isDefault = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhone: null == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      province: null == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      detailAddress: null == detailAddress
          ? _value.detailAddress
          : detailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      addressType: null == addressType
          ? _value.addressType
          : addressType // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressImplCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$$AddressImplCopyWith(
          _$AddressImpl value, $Res Function(_$AddressImpl) then) =
      __$$AddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'contact_name') String contactName,
      @JsonKey(name: 'contact_phone') String contactPhone,
      String province,
      String city,
      String district,
      @JsonKey(name: 'detail_address') String detailAddress,
      double? latitude,
      double? longitude,
      @JsonKey(name: 'address_type') String addressType,
      String? label,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$AddressImplCopyWithImpl<$Res>
    extends _$AddressCopyWithImpl<$Res, _$AddressImpl>
    implements _$$AddressImplCopyWith<$Res> {
  __$$AddressImplCopyWithImpl(
      _$AddressImpl _value, $Res Function(_$AddressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? contactName = null,
    Object? contactPhone = null,
    Object? province = null,
    Object? city = null,
    Object? district = null,
    Object? detailAddress = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? addressType = null,
    Object? label = freezed,
    Object? isDefault = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AddressImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhone: null == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      province: null == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      detailAddress: null == detailAddress
          ? _value.detailAddress
          : detailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      addressType: null == addressType
          ? _value.addressType
          : addressType // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressImpl implements _Address {
  const _$AddressImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'contact_name') required this.contactName,
      @JsonKey(name: 'contact_phone') required this.contactPhone,
      required this.province,
      required this.city,
      required this.district,
      @JsonKey(name: 'detail_address') required this.detailAddress,
      this.latitude,
      this.longitude,
      @JsonKey(name: 'address_type') this.addressType = 'other',
      this.label,
      @JsonKey(name: 'is_default') this.isDefault = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$AddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  @JsonKey(name: 'contact_name')
  final String contactName;
  @override
  @JsonKey(name: 'contact_phone')
  final String contactPhone;
  @override
  final String province;
  @override
  final String city;
  @override
  final String district;
  @override
  @JsonKey(name: 'detail_address')
  final String detailAddress;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey(name: 'address_type')
  final String addressType;
  @override
  final String? label;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Address(id: $id, userId: $userId, contactName: $contactName, contactPhone: $contactPhone, province: $province, city: $city, district: $district, detailAddress: $detailAddress, latitude: $latitude, longitude: $longitude, addressType: $addressType, label: $label, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.detailAddress, detailAddress) ||
                other.detailAddress == detailAddress) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.addressType, addressType) ||
                other.addressType == addressType) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      contactName,
      contactPhone,
      province,
      city,
      district,
      detailAddress,
      latitude,
      longitude,
      addressType,
      label,
      isDefault,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      __$$AddressImplCopyWithImpl<_$AddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressImplToJson(
      this,
    );
  }
}

abstract class _Address implements Address {
  const factory _Address(
      {required final int id,
      @JsonKey(name: 'user_id') required final int userId,
      @JsonKey(name: 'contact_name') required final String contactName,
      @JsonKey(name: 'contact_phone') required final String contactPhone,
      required final String province,
      required final String city,
      required final String district,
      @JsonKey(name: 'detail_address') required final String detailAddress,
      final double? latitude,
      final double? longitude,
      @JsonKey(name: 'address_type') final String addressType,
      final String? label,
      @JsonKey(name: 'is_default') final bool isDefault,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt}) = _$AddressImpl;

  factory _Address.fromJson(Map<String, dynamic> json) = _$AddressImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'contact_name')
  String get contactName;
  @override
  @JsonKey(name: 'contact_phone')
  String get contactPhone;
  @override
  String get province;
  @override
  String get city;
  @override
  String get district;
  @override
  @JsonKey(name: 'detail_address')
  String get detailAddress;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  @JsonKey(name: 'address_type')
  String get addressType;
  @override
  String? get label;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateAddressRequest _$CreateAddressRequestFromJson(Map<String, dynamic> json) {
  return _CreateAddressRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateAddressRequest {
  @JsonKey(name: 'contact_name')
  String get contactName => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_phone')
  String get contactPhone => throw _privateConstructorUsedError;
  String get province => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get district => throw _privateConstructorUsedError;
  @JsonKey(name: 'detail_address')
  String get detailAddress => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_type')
  String? get addressType => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateAddressRequestCopyWith<CreateAddressRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateAddressRequestCopyWith<$Res> {
  factory $CreateAddressRequestCopyWith(CreateAddressRequest value,
          $Res Function(CreateAddressRequest) then) =
      _$CreateAddressRequestCopyWithImpl<$Res, CreateAddressRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'contact_name') String contactName,
      @JsonKey(name: 'contact_phone') String contactPhone,
      String province,
      String city,
      String district,
      @JsonKey(name: 'detail_address') String detailAddress,
      double? latitude,
      double? longitude,
      @JsonKey(name: 'address_type') String? addressType,
      String? label});
}

/// @nodoc
class _$CreateAddressRequestCopyWithImpl<$Res,
        $Val extends CreateAddressRequest>
    implements $CreateAddressRequestCopyWith<$Res> {
  _$CreateAddressRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactName = null,
    Object? contactPhone = null,
    Object? province = null,
    Object? city = null,
    Object? district = null,
    Object? detailAddress = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? addressType = freezed,
    Object? label = freezed,
  }) {
    return _then(_value.copyWith(
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhone: null == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      province: null == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      detailAddress: null == detailAddress
          ? _value.detailAddress
          : detailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      addressType: freezed == addressType
          ? _value.addressType
          : addressType // ignore: cast_nullable_to_non_nullable
              as String?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateAddressRequestImplCopyWith<$Res>
    implements $CreateAddressRequestCopyWith<$Res> {
  factory _$$CreateAddressRequestImplCopyWith(_$CreateAddressRequestImpl value,
          $Res Function(_$CreateAddressRequestImpl) then) =
      __$$CreateAddressRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'contact_name') String contactName,
      @JsonKey(name: 'contact_phone') String contactPhone,
      String province,
      String city,
      String district,
      @JsonKey(name: 'detail_address') String detailAddress,
      double? latitude,
      double? longitude,
      @JsonKey(name: 'address_type') String? addressType,
      String? label});
}

/// @nodoc
class __$$CreateAddressRequestImplCopyWithImpl<$Res>
    extends _$CreateAddressRequestCopyWithImpl<$Res, _$CreateAddressRequestImpl>
    implements _$$CreateAddressRequestImplCopyWith<$Res> {
  __$$CreateAddressRequestImplCopyWithImpl(_$CreateAddressRequestImpl _value,
      $Res Function(_$CreateAddressRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactName = null,
    Object? contactPhone = null,
    Object? province = null,
    Object? city = null,
    Object? district = null,
    Object? detailAddress = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? addressType = freezed,
    Object? label = freezed,
  }) {
    return _then(_$CreateAddressRequestImpl(
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhone: null == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      province: null == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      detailAddress: null == detailAddress
          ? _value.detailAddress
          : detailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      addressType: freezed == addressType
          ? _value.addressType
          : addressType // ignore: cast_nullable_to_non_nullable
              as String?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateAddressRequestImpl implements _CreateAddressRequest {
  const _$CreateAddressRequestImpl(
      {@JsonKey(name: 'contact_name') required this.contactName,
      @JsonKey(name: 'contact_phone') required this.contactPhone,
      required this.province,
      required this.city,
      required this.district,
      @JsonKey(name: 'detail_address') required this.detailAddress,
      this.latitude,
      this.longitude,
      @JsonKey(name: 'address_type') this.addressType,
      this.label});

  factory _$CreateAddressRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateAddressRequestImplFromJson(json);

  @override
  @JsonKey(name: 'contact_name')
  final String contactName;
  @override
  @JsonKey(name: 'contact_phone')
  final String contactPhone;
  @override
  final String province;
  @override
  final String city;
  @override
  final String district;
  @override
  @JsonKey(name: 'detail_address')
  final String detailAddress;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey(name: 'address_type')
  final String? addressType;
  @override
  final String? label;

  @override
  String toString() {
    return 'CreateAddressRequest(contactName: $contactName, contactPhone: $contactPhone, province: $province, city: $city, district: $district, detailAddress: $detailAddress, latitude: $latitude, longitude: $longitude, addressType: $addressType, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateAddressRequestImpl &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.detailAddress, detailAddress) ||
                other.detailAddress == detailAddress) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.addressType, addressType) ||
                other.addressType == addressType) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      contactName,
      contactPhone,
      province,
      city,
      district,
      detailAddress,
      latitude,
      longitude,
      addressType,
      label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateAddressRequestImplCopyWith<_$CreateAddressRequestImpl>
      get copyWith =>
          __$$CreateAddressRequestImplCopyWithImpl<_$CreateAddressRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateAddressRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateAddressRequest implements CreateAddressRequest {
  const factory _CreateAddressRequest(
      {@JsonKey(name: 'contact_name') required final String contactName,
      @JsonKey(name: 'contact_phone') required final String contactPhone,
      required final String province,
      required final String city,
      required final String district,
      @JsonKey(name: 'detail_address') required final String detailAddress,
      final double? latitude,
      final double? longitude,
      @JsonKey(name: 'address_type') final String? addressType,
      final String? label}) = _$CreateAddressRequestImpl;

  factory _CreateAddressRequest.fromJson(Map<String, dynamic> json) =
      _$CreateAddressRequestImpl.fromJson;

  @override
  @JsonKey(name: 'contact_name')
  String get contactName;
  @override
  @JsonKey(name: 'contact_phone')
  String get contactPhone;
  @override
  String get province;
  @override
  String get city;
  @override
  String get district;
  @override
  @JsonKey(name: 'detail_address')
  String get detailAddress;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  @JsonKey(name: 'address_type')
  String? get addressType;
  @override
  String? get label;
  @override
  @JsonKey(ignore: true)
  _$$CreateAddressRequestImplCopyWith<_$CreateAddressRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
