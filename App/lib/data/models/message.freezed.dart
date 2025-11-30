// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user1_id')
  int get user1Id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user2_id')
  int get user2Id => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message')
  String? get lastMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message_at')
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'user1_unread')
  int get user1Unread => throw _privateConstructorUsedError;
  @JsonKey(name: 'user2_unread')
  int get user2Unread => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // 当前用户的未读数（由后端根据当前用户计算）
  @JsonKey(name: 'unread_count')
  int get unreadCount =>
      throw _privateConstructorUsedError; // 对方用户ID（由后端根据当前用户计算）
  @JsonKey(name: 'other_user_id')
  int? get otherUserId => throw _privateConstructorUsedError; // 对方信息
  @JsonKey(name: 'other_party')
  OtherParty? get otherParty => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user1_id') int user1Id,
      @JsonKey(name: 'user2_id') int user2Id,
      @JsonKey(name: 'last_message') String? lastMessage,
      @JsonKey(name: 'last_message_at') DateTime? lastMessageAt,
      @JsonKey(name: 'user1_unread') int user1Unread,
      @JsonKey(name: 'user2_unread') int user2Unread,
      String status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'other_user_id') int? otherUserId,
      @JsonKey(name: 'other_party') OtherParty? otherParty});

  $OtherPartyCopyWith<$Res>? get otherParty;
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user1Id = null,
    Object? user2Id = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? user1Unread = null,
    Object? user2Unread = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? unreadCount = null,
    Object? otherUserId = freezed,
    Object? otherParty = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      user1Id: null == user1Id
          ? _value.user1Id
          : user1Id // ignore: cast_nullable_to_non_nullable
              as int,
      user2Id: null == user2Id
          ? _value.user2Id
          : user2Id // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      user1Unread: null == user1Unread
          ? _value.user1Unread
          : user1Unread // ignore: cast_nullable_to_non_nullable
              as int,
      user2Unread: null == user2Unread
          ? _value.user2Unread
          : user2Unread // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      otherUserId: freezed == otherUserId
          ? _value.otherUserId
          : otherUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      otherParty: freezed == otherParty
          ? _value.otherParty
          : otherParty // ignore: cast_nullable_to_non_nullable
              as OtherParty?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OtherPartyCopyWith<$Res>? get otherParty {
    if (_value.otherParty == null) {
      return null;
    }

    return $OtherPartyCopyWith<$Res>(_value.otherParty!, (value) {
      return _then(_value.copyWith(otherParty: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
          _$ConversationImpl value, $Res Function(_$ConversationImpl) then) =
      __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user1_id') int user1Id,
      @JsonKey(name: 'user2_id') int user2Id,
      @JsonKey(name: 'last_message') String? lastMessage,
      @JsonKey(name: 'last_message_at') DateTime? lastMessageAt,
      @JsonKey(name: 'user1_unread') int user1Unread,
      @JsonKey(name: 'user2_unread') int user2Unread,
      String status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'unread_count') int unreadCount,
      @JsonKey(name: 'other_user_id') int? otherUserId,
      @JsonKey(name: 'other_party') OtherParty? otherParty});

  @override
  $OtherPartyCopyWith<$Res>? get otherParty;
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
      _$ConversationImpl _value, $Res Function(_$ConversationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user1Id = null,
    Object? user2Id = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? user1Unread = null,
    Object? user2Unread = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? unreadCount = null,
    Object? otherUserId = freezed,
    Object? otherParty = freezed,
  }) {
    return _then(_$ConversationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      user1Id: null == user1Id
          ? _value.user1Id
          : user1Id // ignore: cast_nullable_to_non_nullable
              as int,
      user2Id: null == user2Id
          ? _value.user2Id
          : user2Id // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      user1Unread: null == user1Unread
          ? _value.user1Unread
          : user1Unread // ignore: cast_nullable_to_non_nullable
              as int,
      user2Unread: null == user2Unread
          ? _value.user2Unread
          : user2Unread // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      otherUserId: freezed == otherUserId
          ? _value.otherUserId
          : otherUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      otherParty: freezed == otherParty
          ? _value.otherParty
          : otherParty // ignore: cast_nullable_to_non_nullable
              as OtherParty?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl implements _Conversation {
  const _$ConversationImpl(
      {required this.id,
      @JsonKey(name: 'user1_id') required this.user1Id,
      @JsonKey(name: 'user2_id') required this.user2Id,
      @JsonKey(name: 'last_message') this.lastMessage,
      @JsonKey(name: 'last_message_at') this.lastMessageAt,
      @JsonKey(name: 'user1_unread') this.user1Unread = 0,
      @JsonKey(name: 'user2_unread') this.user2Unread = 0,
      this.status = 'active',
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'unread_count') this.unreadCount = 0,
      @JsonKey(name: 'other_user_id') this.otherUserId,
      @JsonKey(name: 'other_party') this.otherParty});

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user1_id')
  final int user1Id;
  @override
  @JsonKey(name: 'user2_id')
  final int user2Id;
  @override
  @JsonKey(name: 'last_message')
  final String? lastMessage;
  @override
  @JsonKey(name: 'last_message_at')
  final DateTime? lastMessageAt;
  @override
  @JsonKey(name: 'user1_unread')
  final int user1Unread;
  @override
  @JsonKey(name: 'user2_unread')
  final int user2Unread;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
// 当前用户的未读数（由后端根据当前用户计算）
  @override
  @JsonKey(name: 'unread_count')
  final int unreadCount;
// 对方用户ID（由后端根据当前用户计算）
  @override
  @JsonKey(name: 'other_user_id')
  final int? otherUserId;
// 对方信息
  @override
  @JsonKey(name: 'other_party')
  final OtherParty? otherParty;

  @override
  String toString() {
    return 'Conversation(id: $id, user1Id: $user1Id, user2Id: $user2Id, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, user1Unread: $user1Unread, user2Unread: $user2Unread, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, unreadCount: $unreadCount, otherUserId: $otherUserId, otherParty: $otherParty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user1Id, user1Id) || other.user1Id == user1Id) &&
            (identical(other.user2Id, user2Id) || other.user2Id == user2Id) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.user1Unread, user1Unread) ||
                other.user1Unread == user1Unread) &&
            (identical(other.user2Unread, user2Unread) ||
                other.user2Unread == user2Unread) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.otherUserId, otherUserId) ||
                other.otherUserId == otherUserId) &&
            (identical(other.otherParty, otherParty) ||
                other.otherParty == otherParty));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      user1Id,
      user2Id,
      lastMessage,
      lastMessageAt,
      user1Unread,
      user2Unread,
      status,
      createdAt,
      updatedAt,
      unreadCount,
      otherUserId,
      otherParty);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(
      this,
    );
  }
}

abstract class _Conversation implements Conversation {
  const factory _Conversation(
          {required final int id,
          @JsonKey(name: 'user1_id') required final int user1Id,
          @JsonKey(name: 'user2_id') required final int user2Id,
          @JsonKey(name: 'last_message') final String? lastMessage,
          @JsonKey(name: 'last_message_at') final DateTime? lastMessageAt,
          @JsonKey(name: 'user1_unread') final int user1Unread,
          @JsonKey(name: 'user2_unread') final int user2Unread,
          final String status,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'unread_count') final int unreadCount,
          @JsonKey(name: 'other_user_id') final int? otherUserId,
          @JsonKey(name: 'other_party') final OtherParty? otherParty}) =
      _$ConversationImpl;

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user1_id')
  int get user1Id;
  @override
  @JsonKey(name: 'user2_id')
  int get user2Id;
  @override
  @JsonKey(name: 'last_message')
  String? get lastMessage;
  @override
  @JsonKey(name: 'last_message_at')
  DateTime? get lastMessageAt;
  @override
  @JsonKey(name: 'user1_unread')
  int get user1Unread;
  @override
  @JsonKey(name: 'user2_unread')
  int get user2Unread;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override // 当前用户的未读数（由后端根据当前用户计算）
  @JsonKey(name: 'unread_count')
  int get unreadCount;
  @override // 对方用户ID（由后端根据当前用户计算）
  @JsonKey(name: 'other_user_id')
  int? get otherUserId;
  @override // 对方信息
  @JsonKey(name: 'other_party')
  OtherParty? get otherParty;
  @override
  @JsonKey(ignore: true)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtherParty _$OtherPartyFromJson(Map<String, dynamic> json) {
  return _OtherParty.fromJson(json);
}

/// @nodoc
mixin _$OtherParty {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'nickname')
  String get nickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_type')
  String? get userType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtherPartyCopyWith<OtherParty> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtherPartyCopyWith<$Res> {
  factory $OtherPartyCopyWith(
          OtherParty value, $Res Function(OtherParty) then) =
      _$OtherPartyCopyWithImpl<$Res, OtherParty>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'nickname') String nickname,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'user_type') String? userType});
}

/// @nodoc
class _$OtherPartyCopyWithImpl<$Res, $Val extends OtherParty>
    implements $OtherPartyCopyWith<$Res> {
  _$OtherPartyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? avatarUrl = freezed,
    Object? userType = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      userType: freezed == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtherPartyImplCopyWith<$Res>
    implements $OtherPartyCopyWith<$Res> {
  factory _$$OtherPartyImplCopyWith(
          _$OtherPartyImpl value, $Res Function(_$OtherPartyImpl) then) =
      __$$OtherPartyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'nickname') String nickname,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'user_type') String? userType});
}

/// @nodoc
class __$$OtherPartyImplCopyWithImpl<$Res>
    extends _$OtherPartyCopyWithImpl<$Res, _$OtherPartyImpl>
    implements _$$OtherPartyImplCopyWith<$Res> {
  __$$OtherPartyImplCopyWithImpl(
      _$OtherPartyImpl _value, $Res Function(_$OtherPartyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? avatarUrl = freezed,
    Object? userType = freezed,
  }) {
    return _then(_$OtherPartyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      userType: freezed == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtherPartyImpl implements _OtherParty {
  const _$OtherPartyImpl(
      {required this.id,
      @JsonKey(name: 'nickname') required this.nickname,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'user_type') this.userType});

  factory _$OtherPartyImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtherPartyImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'nickname')
  final String nickname;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'user_type')
  final String? userType;

  @override
  String toString() {
    return 'OtherParty(id: $id, nickname: $nickname, avatarUrl: $avatarUrl, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtherPartyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.userType, userType) ||
                other.userType == userType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nickname, avatarUrl, userType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtherPartyImplCopyWith<_$OtherPartyImpl> get copyWith =>
      __$$OtherPartyImplCopyWithImpl<_$OtherPartyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtherPartyImplToJson(
      this,
    );
  }
}

abstract class _OtherParty implements OtherParty {
  const factory _OtherParty(
      {required final int id,
      @JsonKey(name: 'nickname') required final String nickname,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'user_type') final String? userType}) = _$OtherPartyImpl;

  factory _OtherParty.fromJson(Map<String, dynamic> json) =
      _$OtherPartyImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'nickname')
  String get nickname;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'user_type')
  String? get userType;
  @override
  @JsonKey(ignore: true)
  _$$OtherPartyImplCopyWith<_$OtherPartyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_id')
  int get conversationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_id')
  int get senderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiver_id')
  int get receiverId => throw _privateConstructorUsedError;
  @JsonKey(name: 'content_type')
  String get contentType => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'conversation_id') int conversationId,
      @JsonKey(name: 'sender_id') int senderId,
      @JsonKey(name: 'receiver_id') int receiverId,
      @JsonKey(name: 'content_type') String contentType,
      String content,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? contentType = null,
    Object? content = null,
    Object? isRead = null,
    Object? isDeleted = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as int,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as int,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'conversation_id') int conversationId,
      @JsonKey(name: 'sender_id') int senderId,
      @JsonKey(name: 'receiver_id') int receiverId,
      @JsonKey(name: 'content_type') String contentType,
      String content,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? contentType = null,
    Object? content = null,
    Object? isRead = null,
    Object? isDeleted = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as int,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as int,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {required this.id,
      @JsonKey(name: 'conversation_id') required this.conversationId,
      @JsonKey(name: 'sender_id') required this.senderId,
      @JsonKey(name: 'receiver_id') required this.receiverId,
      @JsonKey(name: 'content_type') this.contentType = 'text',
      required this.content,
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'is_deleted') this.isDeleted = false,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'conversation_id')
  final int conversationId;
  @override
  @JsonKey(name: 'sender_id')
  final int senderId;
  @override
  @JsonKey(name: 'receiver_id')
  final int receiverId;
  @override
  @JsonKey(name: 'content_type')
  final String contentType;
  @override
  final String content;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Message(id: $id, conversationId: $conversationId, senderId: $senderId, receiverId: $receiverId, contentType: $contentType, content: $content, isRead: $isRead, isDeleted: $isDeleted, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, conversationId, senderId,
      receiverId, contentType, content, isRead, isDeleted, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(
      this,
    );
  }
}

abstract class _Message implements Message {
  const factory _Message(
      {required final int id,
      @JsonKey(name: 'conversation_id') required final int conversationId,
      @JsonKey(name: 'sender_id') required final int senderId,
      @JsonKey(name: 'receiver_id') required final int receiverId,
      @JsonKey(name: 'content_type') final String contentType,
      required final String content,
      @JsonKey(name: 'is_read') final bool isRead,
      @JsonKey(name: 'is_deleted') final bool isDeleted,
      @JsonKey(name: 'created_at') final DateTime? createdAt}) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'conversation_id')
  int get conversationId;
  @override
  @JsonKey(name: 'sender_id')
  int get senderId;
  @override
  @JsonKey(name: 'receiver_id')
  int get receiverId;
  @override
  @JsonKey(name: 'content_type')
  String get contentType;
  @override
  String get content;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SendMessageRequest _$SendMessageRequestFromJson(Map<String, dynamic> json) {
  return _SendMessageRequest.fromJson(json);
}

/// @nodoc
mixin _$SendMessageRequest {
  @JsonKey(name: 'content_type')
  String get contentType => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SendMessageRequestCopyWith<SendMessageRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendMessageRequestCopyWith<$Res> {
  factory $SendMessageRequestCopyWith(
          SendMessageRequest value, $Res Function(SendMessageRequest) then) =
      _$SendMessageRequestCopyWithImpl<$Res, SendMessageRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'content_type') String contentType, String content});
}

/// @nodoc
class _$SendMessageRequestCopyWithImpl<$Res, $Val extends SendMessageRequest>
    implements $SendMessageRequestCopyWith<$Res> {
  _$SendMessageRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendMessageRequestImplCopyWith<$Res>
    implements $SendMessageRequestCopyWith<$Res> {
  factory _$$SendMessageRequestImplCopyWith(_$SendMessageRequestImpl value,
          $Res Function(_$SendMessageRequestImpl) then) =
      __$$SendMessageRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'content_type') String contentType, String content});
}

/// @nodoc
class __$$SendMessageRequestImplCopyWithImpl<$Res>
    extends _$SendMessageRequestCopyWithImpl<$Res, _$SendMessageRequestImpl>
    implements _$$SendMessageRequestImplCopyWith<$Res> {
  __$$SendMessageRequestImplCopyWithImpl(_$SendMessageRequestImpl _value,
      $Res Function(_$SendMessageRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
    Object? content = null,
  }) {
    return _then(_$SendMessageRequestImpl(
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendMessageRequestImpl implements _SendMessageRequest {
  const _$SendMessageRequestImpl(
      {@JsonKey(name: 'content_type') this.contentType = 'text',
      required this.content});

  factory _$SendMessageRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendMessageRequestImplFromJson(json);

  @override
  @JsonKey(name: 'content_type')
  final String contentType;
  @override
  final String content;

  @override
  String toString() {
    return 'SendMessageRequest(contentType: $contentType, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendMessageRequestImpl &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, contentType, content);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SendMessageRequestImplCopyWith<_$SendMessageRequestImpl> get copyWith =>
      __$$SendMessageRequestImplCopyWithImpl<_$SendMessageRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendMessageRequestImplToJson(
      this,
    );
  }
}

abstract class _SendMessageRequest implements SendMessageRequest {
  const factory _SendMessageRequest(
      {@JsonKey(name: 'content_type') final String contentType,
      required final String content}) = _$SendMessageRequestImpl;

  factory _SendMessageRequest.fromJson(Map<String, dynamic> json) =
      _$SendMessageRequestImpl.fromJson;

  @override
  @JsonKey(name: 'content_type')
  String get contentType;
  @override
  String get content;
  @override
  @JsonKey(ignore: true)
  _$$SendMessageRequestImplCopyWith<_$SendMessageRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
