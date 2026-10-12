// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_post_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CirclePostDraft {

@JsonKey(name: 'mediaAssets') List<String> get mediaAssets;@JsonKey(name: 'childIds') List<String> get childIds;@JsonKey(name: 'takenAt') DateTime? get takenAt;@JsonKey(name: 'message') String get message;
/// Create a copy of CirclePostDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CirclePostDraftCopyWith<CirclePostDraft> get copyWith => _$CirclePostDraftCopyWithImpl<CirclePostDraft>(this as CirclePostDraft, _$identity);

  /// Serializes this CirclePostDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CirclePostDraft&&const DeepCollectionEquality().equals(other.mediaAssets, mediaAssets)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(mediaAssets),const DeepCollectionEquality().hash(childIds),takenAt,message);

@override
String toString() {
  return 'CirclePostDraft(mediaAssets: $mediaAssets, childIds: $childIds, takenAt: $takenAt, message: $message)';
}


}

/// @nodoc
abstract mixin class $CirclePostDraftCopyWith<$Res>  {
  factory $CirclePostDraftCopyWith(CirclePostDraft value, $Res Function(CirclePostDraft) _then) = _$CirclePostDraftCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'mediaAssets') List<String> mediaAssets,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'takenAt') DateTime? takenAt,@JsonKey(name: 'message') String message
});




}
/// @nodoc
class _$CirclePostDraftCopyWithImpl<$Res>
    implements $CirclePostDraftCopyWith<$Res> {
  _$CirclePostDraftCopyWithImpl(this._self, this._then);

  final CirclePostDraft _self;
  final $Res Function(CirclePostDraft) _then;

/// Create a copy of CirclePostDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mediaAssets = null,Object? childIds = null,Object? takenAt = freezed,Object? message = null,}) {
  return _then(_self.copyWith(
mediaAssets: null == mediaAssets ? _self.mediaAssets : mediaAssets // ignore: cast_nullable_to_non_nullable
as List<String>,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CirclePostDraft].
extension CirclePostDraftPatterns on CirclePostDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CirclePostDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CirclePostDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CirclePostDraft value)  $default,){
final _that = this;
switch (_that) {
case _CirclePostDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CirclePostDraft value)?  $default,){
final _that = this;
switch (_that) {
case _CirclePostDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CirclePostDraft implements CirclePostDraft {
  const _CirclePostDraft({@JsonKey(name: 'mediaAssets') final  List<String> mediaAssets = const [], @JsonKey(name: 'childIds') final  List<String> childIds = const [], @JsonKey(name: 'takenAt') this.takenAt, @JsonKey(name: 'message') this.message = ''}): _mediaAssets = mediaAssets,_childIds = childIds;
  factory _CirclePostDraft.fromJson(Map<String, dynamic> json) => _$CirclePostDraftFromJson(json);

 final  List<String> _mediaAssets;
@override@JsonKey(name: 'mediaAssets') List<String> get mediaAssets {
  if (_mediaAssets is EqualUnmodifiableListView) return _mediaAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaAssets);
}

 final  List<String> _childIds;
@override@JsonKey(name: 'childIds') List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

@override@JsonKey(name: 'takenAt') final  DateTime? takenAt;
@override@JsonKey(name: 'message') final  String message;

/// Create a copy of CirclePostDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CirclePostDraftCopyWith<_CirclePostDraft> get copyWith => __$CirclePostDraftCopyWithImpl<_CirclePostDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CirclePostDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CirclePostDraft&&const DeepCollectionEquality().equals(other._mediaAssets, _mediaAssets)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_mediaAssets),const DeepCollectionEquality().hash(_childIds),takenAt,message);

@override
String toString() {
  return 'CirclePostDraft(mediaAssets: $mediaAssets, childIds: $childIds, takenAt: $takenAt, message: $message)';
}


}

/// @nodoc
abstract mixin class _$CirclePostDraftCopyWith<$Res> implements $CirclePostDraftCopyWith<$Res> {
  factory _$CirclePostDraftCopyWith(_CirclePostDraft value, $Res Function(_CirclePostDraft) _then) = __$CirclePostDraftCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'mediaAssets') List<String> mediaAssets,@JsonKey(name: 'childIds') List<String> childIds,@JsonKey(name: 'takenAt') DateTime? takenAt,@JsonKey(name: 'message') String message
});




}
/// @nodoc
class __$CirclePostDraftCopyWithImpl<$Res>
    implements _$CirclePostDraftCopyWith<$Res> {
  __$CirclePostDraftCopyWithImpl(this._self, this._then);

  final _CirclePostDraft _self;
  final $Res Function(_CirclePostDraft) _then;

/// Create a copy of CirclePostDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mediaAssets = null,Object? childIds = null,Object? takenAt = freezed,Object? message = null,}) {
  return _then(_CirclePostDraft(
mediaAssets: null == mediaAssets ? _self._mediaAssets : mediaAssets // ignore: cast_nullable_to_non_nullable
as List<String>,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
