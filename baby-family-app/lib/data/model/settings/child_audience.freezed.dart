// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_audience.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChildAudience {

@JsonKey(name: 'childId') String get childId;@JsonKey(name: 'relativeCount') int get relativeCount;
/// Create a copy of ChildAudience
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildAudienceCopyWith<ChildAudience> get copyWith => _$ChildAudienceCopyWithImpl<ChildAudience>(this as ChildAudience, _$identity);

  /// Serializes this ChildAudience to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildAudience&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.relativeCount, relativeCount) || other.relativeCount == relativeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,relativeCount);

@override
String toString() {
  return 'ChildAudience(childId: $childId, relativeCount: $relativeCount)';
}


}

/// @nodoc
abstract mixin class $ChildAudienceCopyWith<$Res>  {
  factory $ChildAudienceCopyWith(ChildAudience value, $Res Function(ChildAudience) _then) = _$ChildAudienceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'relativeCount') int relativeCount
});




}
/// @nodoc
class _$ChildAudienceCopyWithImpl<$Res>
    implements $ChildAudienceCopyWith<$Res> {
  _$ChildAudienceCopyWithImpl(this._self, this._then);

  final ChildAudience _self;
  final $Res Function(ChildAudience) _then;

/// Create a copy of ChildAudience
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = null,Object? relativeCount = null,}) {
  return _then(_self.copyWith(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,relativeCount: null == relativeCount ? _self.relativeCount : relativeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildAudience].
extension ChildAudiencePatterns on ChildAudience {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildAudience value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildAudience() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildAudience value)  $default,){
final _that = this;
switch (_that) {
case _ChildAudience():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildAudience value)?  $default,){
final _that = this;
switch (_that) {
case _ChildAudience() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChildAudience implements ChildAudience {
  const _ChildAudience({@JsonKey(name: 'childId') required this.childId, @JsonKey(name: 'relativeCount') this.relativeCount = 0});
  factory _ChildAudience.fromJson(Map<String, dynamic> json) => _$ChildAudienceFromJson(json);

@override@JsonKey(name: 'childId') final  String childId;
@override@JsonKey(name: 'relativeCount') final  int relativeCount;

/// Create a copy of ChildAudience
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildAudienceCopyWith<_ChildAudience> get copyWith => __$ChildAudienceCopyWithImpl<_ChildAudience>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildAudienceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildAudience&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.relativeCount, relativeCount) || other.relativeCount == relativeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,childId,relativeCount);

@override
String toString() {
  return 'ChildAudience(childId: $childId, relativeCount: $relativeCount)';
}


}

/// @nodoc
abstract mixin class _$ChildAudienceCopyWith<$Res> implements $ChildAudienceCopyWith<$Res> {
  factory _$ChildAudienceCopyWith(_ChildAudience value, $Res Function(_ChildAudience) _then) = __$ChildAudienceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'childId') String childId,@JsonKey(name: 'relativeCount') int relativeCount
});




}
/// @nodoc
class __$ChildAudienceCopyWithImpl<$Res>
    implements _$ChildAudienceCopyWith<$Res> {
  __$ChildAudienceCopyWithImpl(this._self, this._then);

  final _ChildAudience _self;
  final $Res Function(_ChildAudience) _then;

/// Create a copy of ChildAudience
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = null,Object? relativeCount = null,}) {
  return _then(_ChildAudience(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,relativeCount: null == relativeCount ? _self.relativeCount : relativeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
