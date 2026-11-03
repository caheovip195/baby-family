// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessage {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'conversationId') String get conversationId;@JsonKey(name: 'seq') int get seq;@JsonKey(name: 'senderUserId') String get senderUserId;@JsonKey(name: 'body') String get body;@JsonKey(name: 'isMine') bool get isMine;@JsonKey(name: 'clientKey') String? get clientKey;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'localState') String? get localState;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.senderUserId, senderUserId) || other.senderUserId == senderUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.clientKey, clientKey) || other.clientKey == clientKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.localState, localState) || other.localState == localState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,seq,senderUserId,body,isMine,clientKey,createdAt,localState);

@override
String toString() {
  return 'ChatMessage(id: $id, conversationId: $conversationId, seq: $seq, senderUserId: $senderUserId, body: $body, isMine: $isMine, clientKey: $clientKey, createdAt: $createdAt, localState: $localState)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'conversationId') String conversationId,@JsonKey(name: 'seq') int seq,@JsonKey(name: 'senderUserId') String senderUserId,@JsonKey(name: 'body') String body,@JsonKey(name: 'isMine') bool isMine,@JsonKey(name: 'clientKey') String? clientKey,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'localState') String? localState
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? seq = null,Object? senderUserId = null,Object? body = null,Object? isMine = null,Object? clientKey = freezed,Object? createdAt = freezed,Object? localState = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,senderUserId: null == senderUserId ? _self.senderUserId : senderUserId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,clientKey: freezed == clientKey ? _self.clientKey : clientKey // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,localState: freezed == localState ? _self.localState : localState // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChatMessage extends ChatMessage {
  const _ChatMessage({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'conversationId') this.conversationId = '', @JsonKey(name: 'seq') this.seq = 0, @JsonKey(name: 'senderUserId') this.senderUserId = '', @JsonKey(name: 'body') this.body = '', @JsonKey(name: 'isMine') this.isMine = false, @JsonKey(name: 'clientKey') this.clientKey, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'localState') this.localState}): super._();
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'conversationId') final  String conversationId;
@override@JsonKey(name: 'seq') final  int seq;
@override@JsonKey(name: 'senderUserId') final  String senderUserId;
@override@JsonKey(name: 'body') final  String body;
@override@JsonKey(name: 'isMine') final  bool isMine;
@override@JsonKey(name: 'clientKey') final  String? clientKey;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'localState') final  String? localState;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.senderUserId, senderUserId) || other.senderUserId == senderUserId)&&(identical(other.body, body) || other.body == body)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.clientKey, clientKey) || other.clientKey == clientKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.localState, localState) || other.localState == localState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,seq,senderUserId,body,isMine,clientKey,createdAt,localState);

@override
String toString() {
  return 'ChatMessage(id: $id, conversationId: $conversationId, seq: $seq, senderUserId: $senderUserId, body: $body, isMine: $isMine, clientKey: $clientKey, createdAt: $createdAt, localState: $localState)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'conversationId') String conversationId,@JsonKey(name: 'seq') int seq,@JsonKey(name: 'senderUserId') String senderUserId,@JsonKey(name: 'body') String body,@JsonKey(name: 'isMine') bool isMine,@JsonKey(name: 'clientKey') String? clientKey,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'localState') String? localState
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? seq = null,Object? senderUserId = null,Object? body = null,Object? isMine = null,Object? clientKey = freezed,Object? createdAt = freezed,Object? localState = freezed,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,senderUserId: null == senderUserId ? _self.senderUserId : senderUserId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,clientKey: freezed == clientKey ? _self.clientKey : clientKey // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,localState: freezed == localState ? _self.localState : localState // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
