// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AiChatRequest _$AiChatRequestFromJson(Map<String, dynamic> json) {
  return _AiChatRequest.fromJson(json);
}

/// @nodoc
mixin _$AiChatRequest {
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String? get sessionId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AiChatRequestCopyWith<AiChatRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiChatRequestCopyWith<$Res> {
  factory $AiChatRequestCopyWith(
          AiChatRequest value, $Res Function(AiChatRequest) then) =
      _$AiChatRequestCopyWithImpl<$Res, AiChatRequest>;
  @useResult
  $Res call({String message, @JsonKey(name: 'session_id') String? sessionId});
}

/// @nodoc
class _$AiChatRequestCopyWithImpl<$Res, $Val extends AiChatRequest>
    implements $AiChatRequestCopyWith<$Res> {
  _$AiChatRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? sessionId = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiChatRequestImplCopyWith<$Res>
    implements $AiChatRequestCopyWith<$Res> {
  factory _$$AiChatRequestImplCopyWith(
          _$AiChatRequestImpl value, $Res Function(_$AiChatRequestImpl) then) =
      __$$AiChatRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, @JsonKey(name: 'session_id') String? sessionId});
}

/// @nodoc
class __$$AiChatRequestImplCopyWithImpl<$Res>
    extends _$AiChatRequestCopyWithImpl<$Res, _$AiChatRequestImpl>
    implements _$$AiChatRequestImplCopyWith<$Res> {
  __$$AiChatRequestImplCopyWithImpl(
      _$AiChatRequestImpl _value, $Res Function(_$AiChatRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? sessionId = freezed,
  }) {
    return _then(_$AiChatRequestImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiChatRequestImpl implements _AiChatRequest {
  const _$AiChatRequestImpl(
      {required this.message, @JsonKey(name: 'session_id') this.sessionId});

  factory _$AiChatRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiChatRequestImplFromJson(json);

  @override
  final String message;
  @override
  @JsonKey(name: 'session_id')
  final String? sessionId;

  @override
  String toString() {
    return 'AiChatRequest(message: $message, sessionId: $sessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiChatRequestImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, sessionId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AiChatRequestImplCopyWith<_$AiChatRequestImpl> get copyWith =>
      __$$AiChatRequestImplCopyWithImpl<_$AiChatRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiChatRequestImplToJson(
      this,
    );
  }
}

abstract class _AiChatRequest implements AiChatRequest {
  const factory _AiChatRequest(
          {required final String message,
          @JsonKey(name: 'session_id') final String? sessionId}) =
      _$AiChatRequestImpl;

  factory _AiChatRequest.fromJson(Map<String, dynamic> json) =
      _$AiChatRequestImpl.fromJson;

  @override
  String get message;
  @override
  @JsonKey(name: 'session_id')
  String? get sessionId;
  @override
  @JsonKey(ignore: true)
  _$$AiChatRequestImplCopyWith<_$AiChatRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiChatResponse _$AiChatResponseFromJson(Map<String, dynamic> json) {
  return _AiChatResponse.fromJson(json);
}

/// @nodoc
mixin _$AiChatResponse {
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String? get sessionId => throw _privateConstructorUsedError;
  String? get intent => throw _privateConstructorUsedError;
  Map<String, dynamic>? get entities => throw _privateConstructorUsedError;
  List<Companion>? get recommendations => throw _privateConstructorUsedError;
  @JsonKey(name: 'institution_recommendations')
  List<Institution>? get institutionRecommendations =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'collected_info')
  Map<String, dynamic>? get collectedInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AiChatResponseCopyWith<AiChatResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiChatResponseCopyWith<$Res> {
  factory $AiChatResponseCopyWith(
          AiChatResponse value, $Res Function(AiChatResponse) then) =
      _$AiChatResponseCopyWithImpl<$Res, AiChatResponse>;
  @useResult
  $Res call(
      {String message,
      @JsonKey(name: 'session_id') String? sessionId,
      String? intent,
      Map<String, dynamic>? entities,
      List<Companion>? recommendations,
      @JsonKey(name: 'institution_recommendations')
      List<Institution>? institutionRecommendations,
      @JsonKey(name: 'collected_info') Map<String, dynamic>? collectedInfo,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$AiChatResponseCopyWithImpl<$Res, $Val extends AiChatResponse>
    implements $AiChatResponseCopyWith<$Res> {
  _$AiChatResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? sessionId = freezed,
    Object? intent = freezed,
    Object? entities = freezed,
    Object? recommendations = freezed,
    Object? institutionRecommendations = freezed,
    Object? collectedInfo = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      intent: freezed == intent
          ? _value.intent
          : intent // ignore: cast_nullable_to_non_nullable
              as String?,
      entities: freezed == entities
          ? _value.entities
          : entities // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      recommendations: freezed == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<Companion>?,
      institutionRecommendations: freezed == institutionRecommendations
          ? _value.institutionRecommendations
          : institutionRecommendations // ignore: cast_nullable_to_non_nullable
              as List<Institution>?,
      collectedInfo: freezed == collectedInfo
          ? _value.collectedInfo
          : collectedInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiChatResponseImplCopyWith<$Res>
    implements $AiChatResponseCopyWith<$Res> {
  factory _$$AiChatResponseImplCopyWith(_$AiChatResponseImpl value,
          $Res Function(_$AiChatResponseImpl) then) =
      __$$AiChatResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      @JsonKey(name: 'session_id') String? sessionId,
      String? intent,
      Map<String, dynamic>? entities,
      List<Companion>? recommendations,
      @JsonKey(name: 'institution_recommendations')
      List<Institution>? institutionRecommendations,
      @JsonKey(name: 'collected_info') Map<String, dynamic>? collectedInfo,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$AiChatResponseImplCopyWithImpl<$Res>
    extends _$AiChatResponseCopyWithImpl<$Res, _$AiChatResponseImpl>
    implements _$$AiChatResponseImplCopyWith<$Res> {
  __$$AiChatResponseImplCopyWithImpl(
      _$AiChatResponseImpl _value, $Res Function(_$AiChatResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? sessionId = freezed,
    Object? intent = freezed,
    Object? entities = freezed,
    Object? recommendations = freezed,
    Object? institutionRecommendations = freezed,
    Object? collectedInfo = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AiChatResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      intent: freezed == intent
          ? _value.intent
          : intent // ignore: cast_nullable_to_non_nullable
              as String?,
      entities: freezed == entities
          ? _value._entities
          : entities // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      recommendations: freezed == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<Companion>?,
      institutionRecommendations: freezed == institutionRecommendations
          ? _value._institutionRecommendations
          : institutionRecommendations // ignore: cast_nullable_to_non_nullable
              as List<Institution>?,
      collectedInfo: freezed == collectedInfo
          ? _value._collectedInfo
          : collectedInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiChatResponseImpl implements _AiChatResponse {
  const _$AiChatResponseImpl(
      {required this.message,
      @JsonKey(name: 'session_id') this.sessionId,
      this.intent,
      final Map<String, dynamic>? entities,
      final List<Companion>? recommendations,
      @JsonKey(name: 'institution_recommendations')
      final List<Institution>? institutionRecommendations,
      @JsonKey(name: 'collected_info')
      final Map<String, dynamic>? collectedInfo,
      @JsonKey(name: 'created_at') this.createdAt})
      : _entities = entities,
        _recommendations = recommendations,
        _institutionRecommendations = institutionRecommendations,
        _collectedInfo = collectedInfo;

  factory _$AiChatResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiChatResponseImplFromJson(json);

  @override
  final String message;
  @override
  @JsonKey(name: 'session_id')
  final String? sessionId;
  @override
  final String? intent;
  final Map<String, dynamic>? _entities;
  @override
  Map<String, dynamic>? get entities {
    final value = _entities;
    if (value == null) return null;
    if (_entities is EqualUnmodifiableMapView) return _entities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<Companion>? _recommendations;
  @override
  List<Companion>? get recommendations {
    final value = _recommendations;
    if (value == null) return null;
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Institution>? _institutionRecommendations;
  @override
  @JsonKey(name: 'institution_recommendations')
  List<Institution>? get institutionRecommendations {
    final value = _institutionRecommendations;
    if (value == null) return null;
    if (_institutionRecommendations is EqualUnmodifiableListView)
      return _institutionRecommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _collectedInfo;
  @override
  @JsonKey(name: 'collected_info')
  Map<String, dynamic>? get collectedInfo {
    final value = _collectedInfo;
    if (value == null) return null;
    if (_collectedInfo is EqualUnmodifiableMapView) return _collectedInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AiChatResponse(message: $message, sessionId: $sessionId, intent: $intent, entities: $entities, recommendations: $recommendations, institutionRecommendations: $institutionRecommendations, collectedInfo: $collectedInfo, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiChatResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.intent, intent) || other.intent == intent) &&
            const DeepCollectionEquality().equals(other._entities, _entities) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            const DeepCollectionEquality().equals(
                other._institutionRecommendations,
                _institutionRecommendations) &&
            const DeepCollectionEquality()
                .equals(other._collectedInfo, _collectedInfo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      message,
      sessionId,
      intent,
      const DeepCollectionEquality().hash(_entities),
      const DeepCollectionEquality().hash(_recommendations),
      const DeepCollectionEquality().hash(_institutionRecommendations),
      const DeepCollectionEquality().hash(_collectedInfo),
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AiChatResponseImplCopyWith<_$AiChatResponseImpl> get copyWith =>
      __$$AiChatResponseImplCopyWithImpl<_$AiChatResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiChatResponseImplToJson(
      this,
    );
  }
}

abstract class _AiChatResponse implements AiChatResponse {
  const factory _AiChatResponse(
          {required final String message,
          @JsonKey(name: 'session_id') final String? sessionId,
          final String? intent,
          final Map<String, dynamic>? entities,
          final List<Companion>? recommendations,
          @JsonKey(name: 'institution_recommendations')
          final List<Institution>? institutionRecommendations,
          @JsonKey(name: 'collected_info')
          final Map<String, dynamic>? collectedInfo,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$AiChatResponseImpl;

  factory _AiChatResponse.fromJson(Map<String, dynamic> json) =
      _$AiChatResponseImpl.fromJson;

  @override
  String get message;
  @override
  @JsonKey(name: 'session_id')
  String? get sessionId;
  @override
  String? get intent;
  @override
  Map<String, dynamic>? get entities;
  @override
  List<Companion>? get recommendations;
  @override
  @JsonKey(name: 'institution_recommendations')
  List<Institution>? get institutionRecommendations;
  @override
  @JsonKey(name: 'collected_info')
  Map<String, dynamic>? get collectedInfo;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$AiChatResponseImplCopyWith<_$AiChatResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiChatMessage _$AiChatMessageFromJson(Map<String, dynamic> json) {
  return _AiChatMessage.fromJson(json);
}

/// @nodoc
mixin _$AiChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // user/assistant/system
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<Companion>? get recommendations =>
      throw _privateConstructorUsedError; // AI 推荐的陪诊师
  @JsonKey(name: 'institution_recommendations')
  List<Institution>? get institutionRecommendations =>
      throw _privateConstructorUsedError; // AI 推荐的陪诊机构
  bool? get isLoading => throw _privateConstructorUsedError; // 是否正在加载
  @JsonKey(name: 'order_card')
  Map<String, dynamic>? get orderCard => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AiChatMessageCopyWith<AiChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiChatMessageCopyWith<$Res> {
  factory $AiChatMessageCopyWith(
          AiChatMessage value, $Res Function(AiChatMessage) then) =
      _$AiChatMessageCopyWithImpl<$Res, AiChatMessage>;
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      @JsonKey(name: 'created_at') DateTime createdAt,
      List<Companion>? recommendations,
      @JsonKey(name: 'institution_recommendations')
      List<Institution>? institutionRecommendations,
      bool? isLoading,
      @JsonKey(name: 'order_card') Map<String, dynamic>? orderCard});
}

/// @nodoc
class _$AiChatMessageCopyWithImpl<$Res, $Val extends AiChatMessage>
    implements $AiChatMessageCopyWith<$Res> {
  _$AiChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
    Object? recommendations = freezed,
    Object? institutionRecommendations = freezed,
    Object? isLoading = freezed,
    Object? orderCard = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recommendations: freezed == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<Companion>?,
      institutionRecommendations: freezed == institutionRecommendations
          ? _value.institutionRecommendations
          : institutionRecommendations // ignore: cast_nullable_to_non_nullable
              as List<Institution>?,
      isLoading: freezed == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool?,
      orderCard: freezed == orderCard
          ? _value.orderCard
          : orderCard // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiChatMessageImplCopyWith<$Res>
    implements $AiChatMessageCopyWith<$Res> {
  factory _$$AiChatMessageImplCopyWith(
          _$AiChatMessageImpl value, $Res Function(_$AiChatMessageImpl) then) =
      __$$AiChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      @JsonKey(name: 'created_at') DateTime createdAt,
      List<Companion>? recommendations,
      @JsonKey(name: 'institution_recommendations')
      List<Institution>? institutionRecommendations,
      bool? isLoading,
      @JsonKey(name: 'order_card') Map<String, dynamic>? orderCard});
}

/// @nodoc
class __$$AiChatMessageImplCopyWithImpl<$Res>
    extends _$AiChatMessageCopyWithImpl<$Res, _$AiChatMessageImpl>
    implements _$$AiChatMessageImplCopyWith<$Res> {
  __$$AiChatMessageImplCopyWithImpl(
      _$AiChatMessageImpl _value, $Res Function(_$AiChatMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
    Object? recommendations = freezed,
    Object? institutionRecommendations = freezed,
    Object? isLoading = freezed,
    Object? orderCard = freezed,
  }) {
    return _then(_$AiChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recommendations: freezed == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<Companion>?,
      institutionRecommendations: freezed == institutionRecommendations
          ? _value._institutionRecommendations
          : institutionRecommendations // ignore: cast_nullable_to_non_nullable
              as List<Institution>?,
      isLoading: freezed == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool?,
      orderCard: freezed == orderCard
          ? _value._orderCard
          : orderCard // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiChatMessageImpl implements _AiChatMessage {
  const _$AiChatMessageImpl(
      {required this.id,
      required this.role,
      required this.content,
      @JsonKey(name: 'created_at') required this.createdAt,
      final List<Companion>? recommendations,
      @JsonKey(name: 'institution_recommendations')
      final List<Institution>? institutionRecommendations,
      this.isLoading,
      @JsonKey(name: 'order_card') final Map<String, dynamic>? orderCard})
      : _recommendations = recommendations,
        _institutionRecommendations = institutionRecommendations,
        _orderCard = orderCard;

  factory _$AiChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String role;
// user/assistant/system
  @override
  final String content;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final List<Companion>? _recommendations;
  @override
  List<Companion>? get recommendations {
    final value = _recommendations;
    if (value == null) return null;
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// AI 推荐的陪诊师
  final List<Institution>? _institutionRecommendations;
// AI 推荐的陪诊师
  @override
  @JsonKey(name: 'institution_recommendations')
  List<Institution>? get institutionRecommendations {
    final value = _institutionRecommendations;
    if (value == null) return null;
    if (_institutionRecommendations is EqualUnmodifiableListView)
      return _institutionRecommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// AI 推荐的陪诊机构
  @override
  final bool? isLoading;
// 是否正在加载
  final Map<String, dynamic>? _orderCard;
// 是否正在加载
  @override
  @JsonKey(name: 'order_card')
  Map<String, dynamic>? get orderCard {
    final value = _orderCard;
    if (value == null) return null;
    if (_orderCard is EqualUnmodifiableMapView) return _orderCard;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AiChatMessage(id: $id, role: $role, content: $content, createdAt: $createdAt, recommendations: $recommendations, institutionRecommendations: $institutionRecommendations, isLoading: $isLoading, orderCard: $orderCard)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            const DeepCollectionEquality().equals(
                other._institutionRecommendations,
                _institutionRecommendations) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._orderCard, _orderCard));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      role,
      content,
      createdAt,
      const DeepCollectionEquality().hash(_recommendations),
      const DeepCollectionEquality().hash(_institutionRecommendations),
      isLoading,
      const DeepCollectionEquality().hash(_orderCard));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AiChatMessageImplCopyWith<_$AiChatMessageImpl> get copyWith =>
      __$$AiChatMessageImplCopyWithImpl<_$AiChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiChatMessageImplToJson(
      this,
    );
  }
}

abstract class _AiChatMessage implements AiChatMessage {
  const factory _AiChatMessage(
          {required final String id,
          required final String role,
          required final String content,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          final List<Companion>? recommendations,
          @JsonKey(name: 'institution_recommendations')
          final List<Institution>? institutionRecommendations,
          final bool? isLoading,
          @JsonKey(name: 'order_card') final Map<String, dynamic>? orderCard}) =
      _$AiChatMessageImpl;

  factory _AiChatMessage.fromJson(Map<String, dynamic> json) =
      _$AiChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get role;
  @override // user/assistant/system
  String get content;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  List<Companion>? get recommendations;
  @override // AI 推荐的陪诊师
  @JsonKey(name: 'institution_recommendations')
  List<Institution>? get institutionRecommendations;
  @override // AI 推荐的陪诊机构
  bool? get isLoading;
  @override // 是否正在加载
  @JsonKey(name: 'order_card')
  Map<String, dynamic>? get orderCard;
  @override
  @JsonKey(ignore: true)
  _$$AiChatMessageImplCopyWith<_$AiChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AiSession {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AiSessionCopyWith<AiSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiSessionCopyWith<$Res> {
  factory $AiSessionCopyWith(AiSession value, $Res Function(AiSession) then) =
      _$AiSessionCopyWithImpl<$Res, AiSession>;
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$AiSessionCopyWithImpl<$Res, $Val extends AiSession>
    implements $AiSessionCopyWith<$Res> {
  _$AiSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$AiSessionImplCopyWith<$Res>
    implements $AiSessionCopyWith<$Res> {
  factory _$$AiSessionImplCopyWith(
          _$AiSessionImpl value, $Res Function(_$AiSessionImpl) then) =
      __$$AiSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$AiSessionImplCopyWithImpl<$Res>
    extends _$AiSessionCopyWithImpl<$Res, _$AiSessionImpl>
    implements _$$AiSessionImplCopyWith<$Res> {
  __$$AiSessionImplCopyWithImpl(
      _$AiSessionImpl _value, $Res Function(_$AiSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AiSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
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

class _$AiSessionImpl implements _AiSession {
  const _$AiSessionImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AiSession(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AiSessionImplCopyWith<_$AiSessionImpl> get copyWith =>
      __$$AiSessionImplCopyWithImpl<_$AiSessionImpl>(this, _$identity);
}

abstract class _AiSession implements AiSession {
  const factory _AiSession(
          {required final String id,
          required final String title,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$AiSessionImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AiSessionImplCopyWith<_$AiSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
