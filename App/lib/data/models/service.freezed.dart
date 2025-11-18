// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return _Service.fromJson(json);
}

/// @nodoc
mixin _$Service {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'companion_id')
  int get companionId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get features => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_price')
  double get basePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'additional_hour_price')
  double? get additionalHourPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_count')
  int get salesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'view_count')
  int get viewCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError; // 服务规格列表
  List<ServiceSpec>? get specs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceCopyWith<Service> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceCopyWith<$Res> {
  factory $ServiceCopyWith(Service value, $Res Function(Service) then) =
      _$ServiceCopyWithImpl<$Res, Service>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'companion_id') int companionId,
      String title,
      String? category,
      String? description,
      List<String>? features,
      @JsonKey(name: 'base_price') double basePrice,
      @JsonKey(name: 'additional_hour_price') double? additionalHourPrice,
      @JsonKey(name: 'sales_count') int salesCount,
      @JsonKey(name: 'view_count') int viewCount,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      List<ServiceSpec>? specs});
}

/// @nodoc
class _$ServiceCopyWithImpl<$Res, $Val extends Service>
    implements $ServiceCopyWith<$Res> {
  _$ServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companionId = null,
    Object? title = null,
    Object? category = freezed,
    Object? description = freezed,
    Object? features = freezed,
    Object? basePrice = null,
    Object? additionalHourPrice = freezed,
    Object? salesCount = null,
    Object? viewCount = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? specs = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companionId: null == companionId
          ? _value.companionId
          : companionId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      features: freezed == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      additionalHourPrice: freezed == additionalHourPrice
          ? _value.additionalHourPrice
          : additionalHourPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      salesCount: null == salesCount
          ? _value.salesCount
          : salesCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      specs: freezed == specs
          ? _value.specs
          : specs // ignore: cast_nullable_to_non_nullable
              as List<ServiceSpec>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceImplCopyWith<$Res> implements $ServiceCopyWith<$Res> {
  factory _$$ServiceImplCopyWith(
          _$ServiceImpl value, $Res Function(_$ServiceImpl) then) =
      __$$ServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'companion_id') int companionId,
      String title,
      String? category,
      String? description,
      List<String>? features,
      @JsonKey(name: 'base_price') double basePrice,
      @JsonKey(name: 'additional_hour_price') double? additionalHourPrice,
      @JsonKey(name: 'sales_count') int salesCount,
      @JsonKey(name: 'view_count') int viewCount,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      List<ServiceSpec>? specs});
}

/// @nodoc
class __$$ServiceImplCopyWithImpl<$Res>
    extends _$ServiceCopyWithImpl<$Res, _$ServiceImpl>
    implements _$$ServiceImplCopyWith<$Res> {
  __$$ServiceImplCopyWithImpl(
      _$ServiceImpl _value, $Res Function(_$ServiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companionId = null,
    Object? title = null,
    Object? category = freezed,
    Object? description = freezed,
    Object? features = freezed,
    Object? basePrice = null,
    Object? additionalHourPrice = freezed,
    Object? salesCount = null,
    Object? viewCount = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? specs = freezed,
  }) {
    return _then(_$ServiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companionId: null == companionId
          ? _value.companionId
          : companionId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      features: freezed == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      additionalHourPrice: freezed == additionalHourPrice
          ? _value.additionalHourPrice
          : additionalHourPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      salesCount: null == salesCount
          ? _value.salesCount
          : salesCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      specs: freezed == specs
          ? _value._specs
          : specs // ignore: cast_nullable_to_non_nullable
              as List<ServiceSpec>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceImpl implements _Service {
  const _$ServiceImpl(
      {required this.id,
      @JsonKey(name: 'companion_id') required this.companionId,
      required this.title,
      this.category,
      this.description,
      final List<String>? features,
      @JsonKey(name: 'base_price') required this.basePrice,
      @JsonKey(name: 'additional_hour_price') this.additionalHourPrice,
      @JsonKey(name: 'sales_count') this.salesCount = 0,
      @JsonKey(name: 'view_count') this.viewCount = 0,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      final List<ServiceSpec>? specs})
      : _features = features,
        _specs = specs;

  factory _$ServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'companion_id')
  final int companionId;
  @override
  final String title;
  @override
  final String? category;
  @override
  final String? description;
  final List<String>? _features;
  @override
  List<String>? get features {
    final value = _features;
    if (value == null) return null;
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'base_price')
  final double basePrice;
  @override
  @JsonKey(name: 'additional_hour_price')
  final double? additionalHourPrice;
  @override
  @JsonKey(name: 'sales_count')
  final int salesCount;
  @override
  @JsonKey(name: 'view_count')
  final int viewCount;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
// 服务规格列表
  final List<ServiceSpec>? _specs;
// 服务规格列表
  @override
  List<ServiceSpec>? get specs {
    final value = _specs;
    if (value == null) return null;
    if (_specs is EqualUnmodifiableListView) return _specs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Service(id: $id, companionId: $companionId, title: $title, category: $category, description: $description, features: $features, basePrice: $basePrice, additionalHourPrice: $additionalHourPrice, salesCount: $salesCount, viewCount: $viewCount, isActive: $isActive, createdAt: $createdAt, specs: $specs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companionId, companionId) ||
                other.companionId == companionId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.additionalHourPrice, additionalHourPrice) ||
                other.additionalHourPrice == additionalHourPrice) &&
            (identical(other.salesCount, salesCount) ||
                other.salesCount == salesCount) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._specs, _specs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companionId,
      title,
      category,
      description,
      const DeepCollectionEquality().hash(_features),
      basePrice,
      additionalHourPrice,
      salesCount,
      viewCount,
      isActive,
      createdAt,
      const DeepCollectionEquality().hash(_specs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceImplCopyWith<_$ServiceImpl> get copyWith =>
      __$$ServiceImplCopyWithImpl<_$ServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceImplToJson(
      this,
    );
  }
}

abstract class _Service implements Service {
  const factory _Service(
      {required final int id,
      @JsonKey(name: 'companion_id') required final int companionId,
      required final String title,
      final String? category,
      final String? description,
      final List<String>? features,
      @JsonKey(name: 'base_price') required final double basePrice,
      @JsonKey(name: 'additional_hour_price') final double? additionalHourPrice,
      @JsonKey(name: 'sales_count') final int salesCount,
      @JsonKey(name: 'view_count') final int viewCount,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      final List<ServiceSpec>? specs}) = _$ServiceImpl;

  factory _Service.fromJson(Map<String, dynamic> json) = _$ServiceImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'companion_id')
  int get companionId;
  @override
  String get title;
  @override
  String? get category;
  @override
  String? get description;
  @override
  List<String>? get features;
  @override
  @JsonKey(name: 'base_price')
  double get basePrice;
  @override
  @JsonKey(name: 'additional_hour_price')
  double? get additionalHourPrice;
  @override
  @JsonKey(name: 'sales_count')
  int get salesCount;
  @override
  @JsonKey(name: 'view_count')
  int get viewCount;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override // 服务规格列表
  List<ServiceSpec>? get specs;
  @override
  @JsonKey(ignore: true)
  _$$ServiceImplCopyWith<_$ServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ServiceSpec _$ServiceSpecFromJson(Map<String, dynamic> json) {
  return _ServiceSpec.fromJson(json);
}

/// @nodoc
mixin _$ServiceSpec {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_id')
  int get serviceId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_hours')
  int get durationHours => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  List<String>? get features => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceSpecCopyWith<ServiceSpec> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceSpecCopyWith<$Res> {
  factory $ServiceSpecCopyWith(
          ServiceSpec value, $Res Function(ServiceSpec) then) =
      _$ServiceSpecCopyWithImpl<$Res, ServiceSpec>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'service_id') int serviceId,
      String name,
      String? description,
      @JsonKey(name: 'duration_hours') int durationHours,
      double price,
      List<String>? features,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$ServiceSpecCopyWithImpl<$Res, $Val extends ServiceSpec>
    implements $ServiceSpecCopyWith<$Res> {
  _$ServiceSpecCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceId = null,
    Object? name = null,
    Object? description = freezed,
    Object? durationHours = null,
    Object? price = null,
    Object? features = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      durationHours: null == durationHours
          ? _value.durationHours
          : durationHours // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      features: freezed == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceSpecImplCopyWith<$Res>
    implements $ServiceSpecCopyWith<$Res> {
  factory _$$ServiceSpecImplCopyWith(
          _$ServiceSpecImpl value, $Res Function(_$ServiceSpecImpl) then) =
      __$$ServiceSpecImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'service_id') int serviceId,
      String name,
      String? description,
      @JsonKey(name: 'duration_hours') int durationHours,
      double price,
      List<String>? features,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$ServiceSpecImplCopyWithImpl<$Res>
    extends _$ServiceSpecCopyWithImpl<$Res, _$ServiceSpecImpl>
    implements _$$ServiceSpecImplCopyWith<$Res> {
  __$$ServiceSpecImplCopyWithImpl(
      _$ServiceSpecImpl _value, $Res Function(_$ServiceSpecImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceId = null,
    Object? name = null,
    Object? description = freezed,
    Object? durationHours = null,
    Object? price = null,
    Object? features = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$ServiceSpecImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      durationHours: null == durationHours
          ? _value.durationHours
          : durationHours // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      features: freezed == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceSpecImpl implements _ServiceSpec {
  const _$ServiceSpecImpl(
      {required this.id,
      @JsonKey(name: 'service_id') required this.serviceId,
      required this.name,
      this.description,
      @JsonKey(name: 'duration_hours') required this.durationHours,
      required this.price,
      final List<String>? features,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'is_active') this.isActive = true})
      : _features = features;

  factory _$ServiceSpecImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceSpecImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'service_id')
  final int serviceId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'duration_hours')
  final int durationHours;
  @override
  final double price;
  final List<String>? _features;
  @override
  List<String>? get features {
    final value = _features;
    if (value == null) return null;
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'ServiceSpec(id: $id, serviceId: $serviceId, name: $name, description: $description, durationHours: $durationHours, price: $price, features: $features, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceSpecImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.durationHours, durationHours) ||
                other.durationHours == durationHours) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      serviceId,
      name,
      description,
      durationHours,
      price,
      const DeepCollectionEquality().hash(_features),
      sortOrder,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceSpecImplCopyWith<_$ServiceSpecImpl> get copyWith =>
      __$$ServiceSpecImplCopyWithImpl<_$ServiceSpecImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceSpecImplToJson(
      this,
    );
  }
}

abstract class _ServiceSpec implements ServiceSpec {
  const factory _ServiceSpec(
      {required final int id,
      @JsonKey(name: 'service_id') required final int serviceId,
      required final String name,
      final String? description,
      @JsonKey(name: 'duration_hours') required final int durationHours,
      required final double price,
      final List<String>? features,
      @JsonKey(name: 'sort_order') final int sortOrder,
      @JsonKey(name: 'is_active') final bool isActive}) = _$ServiceSpecImpl;

  factory _ServiceSpec.fromJson(Map<String, dynamic> json) =
      _$ServiceSpecImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'service_id')
  int get serviceId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'duration_hours')
  int get durationHours;
  @override
  double get price;
  @override
  List<String>? get features;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$ServiceSpecImplCopyWith<_$ServiceSpecImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
