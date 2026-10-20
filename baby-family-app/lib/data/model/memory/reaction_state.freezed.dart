// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReactionState {

@JsonKey(name: 'memoryId') String? get memoryId;@JsonKey(name: 'reactions') Map<String, int> get reactions;@JsonKey(name: 'myReaction') String? get myReaction;@JsonKey(name: 'reactionCount') int get reactionCount;
/// Create a copy of ReactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReactionStateCopyWith<ReactionState> get copyWith => _$ReactionStateCopyWithImpl<ReactionState>(this as ReactionState, _$identity);

  /// Serializes this ReactionState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReactionState&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.reactionCount, reactionCount) || other.reactionCount == reactionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memoryId,const DeepCollectionEquality().hash(reactions),myReaction,reactionCount);

@override
String toString() {
  return 'ReactionState(memoryId: $memoryId, reactions: $reactions, myReaction: $myReaction, reactionCount: $reactionCount)';
}


}

/// @nodoc
abstract mixin class $ReactionStateCopyWith<$Res>  {
  factory $ReactionStateCopyWith(ReactionState value, $Res Function(ReactionState) _then) = _$ReactionStateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'reactions') Map<String, int> reactions,@JsonKey(name: 'myReaction') String? myReaction,@JsonKey(name: 'reactionCount') int reactionCount
});




}
/// @nodoc
class _$ReactionStateCopyWithImpl<$Res>
    implements $ReactionStateCopyWith<$Res> {
  _$ReactionStateCopyWithImpl(this._self, this._then);

  final ReactionState _self;
  final $Res Function(ReactionState) _then;

/// Create a copy of ReactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memoryId = freezed,Object? reactions = null,Object? myReaction = freezed,Object? reactionCount = null,}) {
  return _then(_self.copyWith(
memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,myReaction: freezed == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as String?,reactionCount: null == reactionCount ? _self.reactionCount : reactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReactionState].
extension ReactionStatePatterns on ReactionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReactionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReactionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReactionState value)  $default,){
final _that = this;
switch (_that) {
case _ReactionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReactionState value)?  $default,){
final _that = this;
switch (_that) {
case _ReactionState() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReactionState implements ReactionState {
  const _ReactionState({@JsonKey(name: 'memoryId') this.memoryId, @JsonKey(name: 'reactions') final  Map<String, int> reactions = const <String, int>{}, @JsonKey(name: 'myReaction') this.myReaction, @JsonKey(name: 'reactionCount') this.reactionCount = 0}): _reactions = reactions;
  factory _ReactionState.fromJson(Map<String, dynamic> json) => _$ReactionStateFromJson(json);

@override@JsonKey(name: 'memoryId') final  String? memoryId;
 final  Map<String, int> _reactions;
@override@JsonKey(name: 'reactions') Map<String, int> get reactions {
  if (_reactions is EqualUnmodifiableMapView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_reactions);
}

@override@JsonKey(name: 'myReaction') final  String? myReaction;
@override@JsonKey(name: 'reactionCount') final  int reactionCount;

/// Create a copy of ReactionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReactionStateCopyWith<_ReactionState> get copyWith => __$ReactionStateCopyWithImpl<_ReactionState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReactionStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReactionState&&(identical(other.memoryId, memoryId) || other.memoryId == memoryId)&&const DeepCollectionEquality().equals(other._reactions, _reactions)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.reactionCount, reactionCount) || other.reactionCount == reactionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memoryId,const DeepCollectionEquality().hash(_reactions),myReaction,reactionCount);

@override
String toString() {
  return 'ReactionState(memoryId: $memoryId, reactions: $reactions, myReaction: $myReaction, reactionCount: $reactionCount)';
}


}

/// @nodoc
abstract mixin class _$ReactionStateCopyWith<$Res> implements $ReactionStateCopyWith<$Res> {
  factory _$ReactionStateCopyWith(_ReactionState value, $Res Function(_ReactionState) _then) = __$ReactionStateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'memoryId') String? memoryId,@JsonKey(name: 'reactions') Map<String, int> reactions,@JsonKey(name: 'myReaction') String? myReaction,@JsonKey(name: 'reactionCount') int reactionCount
});




}
/// @nodoc
class __$ReactionStateCopyWithImpl<$Res>
    implements _$ReactionStateCopyWith<$Res> {
  __$ReactionStateCopyWithImpl(this._self, this._then);

  final _ReactionState _self;
  final $Res Function(_ReactionState) _then;

/// Create a copy of ReactionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memoryId = freezed,Object? reactions = null,Object? myReaction = freezed,Object? reactionCount = null,}) {
  return _then(_ReactionState(
memoryId: freezed == memoryId ? _self.memoryId : memoryId // ignore: cast_nullable_to_non_nullable
as String?,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,myReaction: freezed == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as String?,reactionCount: null == reactionCount ? _self.reactionCount : reactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
