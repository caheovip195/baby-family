// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_badge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyBadge {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'title') String get title;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'achievedAt') DateTime? get achievedAt;@JsonKey(name: 'childId') String? get childId;@JsonKey(name: 'hint') String? get hint;@JsonKey(name: 'progress') int? get progress;@JsonKey(name: 'target') int? get target;
/// Create a copy of FamilyBadge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyBadgeCopyWith<FamilyBadge> get copyWith => _$FamilyBadgeCopyWithImpl<FamilyBadge>(this as FamilyBadge, _$identity);

  /// Serializes this FamilyBadge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyBadge&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.achievedAt, achievedAt) || other.achievedAt == achievedAt)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.target, target) || other.target == target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,icon,achievedAt,childId,hint,progress,target);

@override
String toString() {
  return 'FamilyBadge(code: $code, title: $title, icon: $icon, achievedAt: $achievedAt, childId: $childId, hint: $hint, progress: $progress, target: $target)';
}


}

/// @nodoc
abstract mixin class $FamilyBadgeCopyWith<$Res>  {
  factory $FamilyBadgeCopyWith(FamilyBadge value, $Res Function(FamilyBadge) _then) = _$FamilyBadgeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'achievedAt') DateTime? achievedAt,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'hint') String? hint,@JsonKey(name: 'progress') int? progress,@JsonKey(name: 'target') int? target
});




}
/// @nodoc
class _$FamilyBadgeCopyWithImpl<$Res>
    implements $FamilyBadgeCopyWith<$Res> {
  _$FamilyBadgeCopyWithImpl(this._self, this._then);

  final FamilyBadge _self;
  final $Res Function(FamilyBadge) _then;

/// Create a copy of FamilyBadge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? title = null,Object? icon = freezed,Object? achievedAt = freezed,Object? childId = freezed,Object? hint = freezed,Object? progress = freezed,Object? target = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,achievedAt: freezed == achievedAt ? _self.achievedAt : achievedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyBadge].
extension FamilyBadgePatterns on FamilyBadge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyBadge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyBadge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyBadge value)  $default,){
final _that = this;
switch (_that) {
case _FamilyBadge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyBadge value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyBadge() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FamilyBadge extends FamilyBadge {
  const _FamilyBadge({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'achievedAt') this.achievedAt, @JsonKey(name: 'childId') this.childId, @JsonKey(name: 'hint') this.hint, @JsonKey(name: 'progress') this.progress, @JsonKey(name: 'target') this.target}): super._();
  factory _FamilyBadge.fromJson(Map<String, dynamic> json) => _$FamilyBadgeFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'achievedAt') final  DateTime? achievedAt;
@override@JsonKey(name: 'childId') final  String? childId;
@override@JsonKey(name: 'hint') final  String? hint;
@override@JsonKey(name: 'progress') final  int? progress;
@override@JsonKey(name: 'target') final  int? target;

/// Create a copy of FamilyBadge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyBadgeCopyWith<_FamilyBadge> get copyWith => __$FamilyBadgeCopyWithImpl<_FamilyBadge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyBadgeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyBadge&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.achievedAt, achievedAt) || other.achievedAt == achievedAt)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.target, target) || other.target == target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,icon,achievedAt,childId,hint,progress,target);

@override
String toString() {
  return 'FamilyBadge(code: $code, title: $title, icon: $icon, achievedAt: $achievedAt, childId: $childId, hint: $hint, progress: $progress, target: $target)';
}


}

/// @nodoc
abstract mixin class _$FamilyBadgeCopyWith<$Res> implements $FamilyBadgeCopyWith<$Res> {
  factory _$FamilyBadgeCopyWith(_FamilyBadge value, $Res Function(_FamilyBadge) _then) = __$FamilyBadgeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'achievedAt') DateTime? achievedAt,@JsonKey(name: 'childId') String? childId,@JsonKey(name: 'hint') String? hint,@JsonKey(name: 'progress') int? progress,@JsonKey(name: 'target') int? target
});




}
/// @nodoc
class __$FamilyBadgeCopyWithImpl<$Res>
    implements _$FamilyBadgeCopyWith<$Res> {
  __$FamilyBadgeCopyWithImpl(this._self, this._then);

  final _FamilyBadge _self;
  final $Res Function(_FamilyBadge) _then;

/// Create a copy of FamilyBadge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? title = null,Object? icon = freezed,Object? achievedAt = freezed,Object? childId = freezed,Object? hint = freezed,Object? progress = freezed,Object? target = freezed,}) {
  return _then(_FamilyBadge(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,achievedAt: freezed == achievedAt ? _self.achievedAt : achievedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,childId: freezed == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String?,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
