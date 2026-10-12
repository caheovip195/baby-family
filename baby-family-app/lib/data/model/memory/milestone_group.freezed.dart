// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milestone_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MilestoneGroup {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'emoji') String get emoji;@JsonKey(name: 'title') String get title;
/// Create a copy of MilestoneGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneGroupCopyWith<MilestoneGroup> get copyWith => _$MilestoneGroupCopyWithImpl<MilestoneGroup>(this as MilestoneGroup, _$identity);

  /// Serializes this MilestoneGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneGroup&&(identical(other.code, code) || other.code == code)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,emoji,title);

@override
String toString() {
  return 'MilestoneGroup(code: $code, emoji: $emoji, title: $title)';
}


}

/// @nodoc
abstract mixin class $MilestoneGroupCopyWith<$Res>  {
  factory $MilestoneGroupCopyWith(MilestoneGroup value, $Res Function(MilestoneGroup) _then) = _$MilestoneGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'emoji') String emoji,@JsonKey(name: 'title') String title
});




}
/// @nodoc
class _$MilestoneGroupCopyWithImpl<$Res>
    implements $MilestoneGroupCopyWith<$Res> {
  _$MilestoneGroupCopyWithImpl(this._self, this._then);

  final MilestoneGroup _self;
  final $Res Function(MilestoneGroup) _then;

/// Create a copy of MilestoneGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? emoji = null,Object? title = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneGroup].
extension MilestoneGroupPatterns on MilestoneGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneGroup value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneGroup value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneGroup() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MilestoneGroup implements MilestoneGroup {
  const _MilestoneGroup({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'emoji') this.emoji = '', @JsonKey(name: 'title') required this.title});
  factory _MilestoneGroup.fromJson(Map<String, dynamic> json) => _$MilestoneGroupFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'emoji') final  String emoji;
@override@JsonKey(name: 'title') final  String title;

/// Create a copy of MilestoneGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneGroupCopyWith<_MilestoneGroup> get copyWith => __$MilestoneGroupCopyWithImpl<_MilestoneGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneGroup&&(identical(other.code, code) || other.code == code)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,emoji,title);

@override
String toString() {
  return 'MilestoneGroup(code: $code, emoji: $emoji, title: $title)';
}


}

/// @nodoc
abstract mixin class _$MilestoneGroupCopyWith<$Res> implements $MilestoneGroupCopyWith<$Res> {
  factory _$MilestoneGroupCopyWith(_MilestoneGroup value, $Res Function(_MilestoneGroup) _then) = __$MilestoneGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'emoji') String emoji,@JsonKey(name: 'title') String title
});




}
/// @nodoc
class __$MilestoneGroupCopyWithImpl<$Res>
    implements _$MilestoneGroupCopyWith<$Res> {
  __$MilestoneGroupCopyWithImpl(this._self, this._then);

  final _MilestoneGroup _self;
  final $Res Function(_MilestoneGroup) _then;

/// Create a copy of MilestoneGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? emoji = null,Object? title = null,}) {
  return _then(_MilestoneGroup(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
