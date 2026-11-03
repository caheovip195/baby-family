// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_read_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatReadResult {

@JsonKey(name: 'conversationId') String get conversationId;@JsonKey(name: 'readSeq') int get readSeq;
/// Create a copy of ChatReadResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatReadResultCopyWith<ChatReadResult> get copyWith => _$ChatReadResultCopyWithImpl<ChatReadResult>(this as ChatReadResult, _$identity);

  /// Serializes this ChatReadResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatReadResult&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.readSeq, readSeq) || other.readSeq == readSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,readSeq);

@override
String toString() {
  return 'ChatReadResult(conversationId: $conversationId, readSeq: $readSeq)';
}


}

/// @nodoc
abstract mixin class $ChatReadResultCopyWith<$Res>  {
  factory $ChatReadResultCopyWith(ChatReadResult value, $Res Function(ChatReadResult) _then) = _$ChatReadResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conversationId') String conversationId,@JsonKey(name: 'readSeq') int readSeq
});




}
/// @nodoc
class _$ChatReadResultCopyWithImpl<$Res>
    implements $ChatReadResultCopyWith<$Res> {
  _$ChatReadResultCopyWithImpl(this._self, this._then);

  final ChatReadResult _self;
  final $Res Function(ChatReadResult) _then;

/// Create a copy of ChatReadResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? readSeq = null,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,readSeq: null == readSeq ? _self.readSeq : readSeq // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatReadResult].
extension ChatReadResultPatterns on ChatReadResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatReadResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatReadResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatReadResult value)  $default,){
final _that = this;
switch (_that) {
case _ChatReadResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatReadResult value)?  $default,){
final _that = this;
switch (_that) {
case _ChatReadResult() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChatReadResult implements ChatReadResult {
  const _ChatReadResult({@JsonKey(name: 'conversationId') this.conversationId = '', @JsonKey(name: 'readSeq') this.readSeq = 0});
  factory _ChatReadResult.fromJson(Map<String, dynamic> json) => _$ChatReadResultFromJson(json);

@override@JsonKey(name: 'conversationId') final  String conversationId;
@override@JsonKey(name: 'readSeq') final  int readSeq;

/// Create a copy of ChatReadResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatReadResultCopyWith<_ChatReadResult> get copyWith => __$ChatReadResultCopyWithImpl<_ChatReadResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatReadResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatReadResult&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.readSeq, readSeq) || other.readSeq == readSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,readSeq);

@override
String toString() {
  return 'ChatReadResult(conversationId: $conversationId, readSeq: $readSeq)';
}


}

/// @nodoc
abstract mixin class _$ChatReadResultCopyWith<$Res> implements $ChatReadResultCopyWith<$Res> {
  factory _$ChatReadResultCopyWith(_ChatReadResult value, $Res Function(_ChatReadResult) _then) = __$ChatReadResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'conversationId') String conversationId,@JsonKey(name: 'readSeq') int readSeq
});




}
/// @nodoc
class __$ChatReadResultCopyWithImpl<$Res>
    implements _$ChatReadResultCopyWith<$Res> {
  __$ChatReadResultCopyWithImpl(this._self, this._then);

  final _ChatReadResult _self;
  final $Res Function(_ChatReadResult) _then;

/// Create a copy of ChatReadResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? readSeq = null,}) {
  return _then(_ChatReadResult(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,readSeq: null == readSeq ? _self.readSeq : readSeq // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
