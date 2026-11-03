// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatConversation {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'familyId') String get familyId;@JsonKey(name: 'kind') String get kind;@JsonKey(name: 'lastSeq') int get lastSeq;@JsonKey(name: 'readSeq') int get readSeq;@JsonKey(name: 'unreadCount') int get unreadCount;@JsonKey(name: 'lastMessageAt') DateTime? get lastMessageAt;@JsonKey(name: 'lastMessage', fromJson: _chatLastMessage) ChatMessage? get lastMessage;@JsonKey(name: 'members', fromJson: _chatMembers) List<ChatMember> get members;
/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatConversationCopyWith<ChatConversation> get copyWith => _$ChatConversationCopyWithImpl<ChatConversation>(this as ChatConversation, _$identity);

  /// Serializes this ChatConversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.lastSeq, lastSeq) || other.lastSeq == lastSeq)&&(identical(other.readSeq, readSeq) || other.readSeq == readSeq)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,kind,lastSeq,readSeq,unreadCount,lastMessageAt,lastMessage,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'ChatConversation(id: $id, familyId: $familyId, kind: $kind, lastSeq: $lastSeq, readSeq: $readSeq, unreadCount: $unreadCount, lastMessageAt: $lastMessageAt, lastMessage: $lastMessage, members: $members)';
}


}

/// @nodoc
abstract mixin class $ChatConversationCopyWith<$Res>  {
  factory $ChatConversationCopyWith(ChatConversation value, $Res Function(ChatConversation) _then) = _$ChatConversationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'kind') String kind,@JsonKey(name: 'lastSeq') int lastSeq,@JsonKey(name: 'readSeq') int readSeq,@JsonKey(name: 'unreadCount') int unreadCount,@JsonKey(name: 'lastMessageAt') DateTime? lastMessageAt,@JsonKey(name: 'lastMessage', fromJson: _chatLastMessage) ChatMessage? lastMessage,@JsonKey(name: 'members', fromJson: _chatMembers) List<ChatMember> members
});


$ChatMessageCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class _$ChatConversationCopyWithImpl<$Res>
    implements $ChatConversationCopyWith<$Res> {
  _$ChatConversationCopyWithImpl(this._self, this._then);

  final ChatConversation _self;
  final $Res Function(ChatConversation) _then;

/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? familyId = null,Object? kind = null,Object? lastSeq = null,Object? readSeq = null,Object? unreadCount = null,Object? lastMessageAt = freezed,Object? lastMessage = freezed,Object? members = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,lastSeq: null == lastSeq ? _self.lastSeq : lastSeq // ignore: cast_nullable_to_non_nullable
as int,readSeq: null == readSeq ? _self.readSeq : readSeq // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as ChatMessage?,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<ChatMember>,
  ));
}
/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $ChatMessageCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatConversation].
extension ChatConversationPatterns on ChatConversation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatConversation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatConversation value)  $default,){
final _that = this;
switch (_that) {
case _ChatConversation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatConversation value)?  $default,){
final _that = this;
switch (_that) {
case _ChatConversation() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChatConversation extends ChatConversation {
  const _ChatConversation({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'familyId') this.familyId = '', @JsonKey(name: 'kind') this.kind = '', @JsonKey(name: 'lastSeq') this.lastSeq = 0, @JsonKey(name: 'readSeq') this.readSeq = 0, @JsonKey(name: 'unreadCount') this.unreadCount = 0, @JsonKey(name: 'lastMessageAt') this.lastMessageAt, @JsonKey(name: 'lastMessage', fromJson: _chatLastMessage) this.lastMessage, @JsonKey(name: 'members', fromJson: _chatMembers) final  List<ChatMember> members = const <ChatMember>[]}): _members = members,super._();
  factory _ChatConversation.fromJson(Map<String, dynamic> json) => _$ChatConversationFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'familyId') final  String familyId;
@override@JsonKey(name: 'kind') final  String kind;
@override@JsonKey(name: 'lastSeq') final  int lastSeq;
@override@JsonKey(name: 'readSeq') final  int readSeq;
@override@JsonKey(name: 'unreadCount') final  int unreadCount;
@override@JsonKey(name: 'lastMessageAt') final  DateTime? lastMessageAt;
@override@JsonKey(name: 'lastMessage', fromJson: _chatLastMessage) final  ChatMessage? lastMessage;
 final  List<ChatMember> _members;
@override@JsonKey(name: 'members', fromJson: _chatMembers) List<ChatMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}


/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatConversationCopyWith<_ChatConversation> get copyWith => __$ChatConversationCopyWithImpl<_ChatConversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.lastSeq, lastSeq) || other.lastSeq == lastSeq)&&(identical(other.readSeq, readSeq) || other.readSeq == readSeq)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&const DeepCollectionEquality().equals(other._members, _members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,kind,lastSeq,readSeq,unreadCount,lastMessageAt,lastMessage,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'ChatConversation(id: $id, familyId: $familyId, kind: $kind, lastSeq: $lastSeq, readSeq: $readSeq, unreadCount: $unreadCount, lastMessageAt: $lastMessageAt, lastMessage: $lastMessage, members: $members)';
}


}

/// @nodoc
abstract mixin class _$ChatConversationCopyWith<$Res> implements $ChatConversationCopyWith<$Res> {
  factory _$ChatConversationCopyWith(_ChatConversation value, $Res Function(_ChatConversation) _then) = __$ChatConversationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'familyId') String familyId,@JsonKey(name: 'kind') String kind,@JsonKey(name: 'lastSeq') int lastSeq,@JsonKey(name: 'readSeq') int readSeq,@JsonKey(name: 'unreadCount') int unreadCount,@JsonKey(name: 'lastMessageAt') DateTime? lastMessageAt,@JsonKey(name: 'lastMessage', fromJson: _chatLastMessage) ChatMessage? lastMessage,@JsonKey(name: 'members', fromJson: _chatMembers) List<ChatMember> members
});


@override $ChatMessageCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class __$ChatConversationCopyWithImpl<$Res>
    implements _$ChatConversationCopyWith<$Res> {
  __$ChatConversationCopyWithImpl(this._self, this._then);

  final _ChatConversation _self;
  final $Res Function(_ChatConversation) _then;

/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? familyId = null,Object? kind = null,Object? lastSeq = null,Object? readSeq = null,Object? unreadCount = null,Object? lastMessageAt = freezed,Object? lastMessage = freezed,Object? members = null,}) {
  return _then(_ChatConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,lastSeq: null == lastSeq ? _self.lastSeq : lastSeq // ignore: cast_nullable_to_non_nullable
as int,readSeq: null == readSeq ? _self.readSeq : readSeq // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as ChatMessage?,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<ChatMember>,
  ));
}

/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $ChatMessageCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}

// dart format on
