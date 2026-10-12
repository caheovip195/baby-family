// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milestone_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MilestoneOption {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'group') String get group;@JsonKey(name: 'title') String get title;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'recordedAt') DateTime? get recordedAt;@JsonKey(name: 'expectedDate') DateTime? get expectedDate;
/// Create a copy of MilestoneOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneOptionCopyWith<MilestoneOption> get copyWith => _$MilestoneOptionCopyWithImpl<MilestoneOption>(this as MilestoneOption, _$identity);

  /// Serializes this MilestoneOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneOption&&(identical(other.code, code) || other.code == code)&&(identical(other.group, group) || other.group == group)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.expectedDate, expectedDate) || other.expectedDate == expectedDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,group,title,icon,recordedAt,expectedDate);

@override
String toString() {
  return 'MilestoneOption(code: $code, group: $group, title: $title, icon: $icon, recordedAt: $recordedAt, expectedDate: $expectedDate)';
}


}

/// @nodoc
abstract mixin class $MilestoneOptionCopyWith<$Res>  {
  factory $MilestoneOptionCopyWith(MilestoneOption value, $Res Function(MilestoneOption) _then) = _$MilestoneOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'group') String group,@JsonKey(name: 'title') String title,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'recordedAt') DateTime? recordedAt,@JsonKey(name: 'expectedDate') DateTime? expectedDate
});




}
/// @nodoc
class _$MilestoneOptionCopyWithImpl<$Res>
    implements $MilestoneOptionCopyWith<$Res> {
  _$MilestoneOptionCopyWithImpl(this._self, this._then);

  final MilestoneOption _self;
  final $Res Function(MilestoneOption) _then;

/// Create a copy of MilestoneOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? group = null,Object? title = null,Object? icon = freezed,Object? recordedAt = freezed,Object? expectedDate = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,recordedAt: freezed == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedDate: freezed == expectedDate ? _self.expectedDate : expectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneOption].
extension MilestoneOptionPatterns on MilestoneOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneOption value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneOption value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneOption() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MilestoneOption extends MilestoneOption {
  const _MilestoneOption({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'group') required this.group, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'recordedAt') this.recordedAt, @JsonKey(name: 'expectedDate') this.expectedDate}): super._();
  factory _MilestoneOption.fromJson(Map<String, dynamic> json) => _$MilestoneOptionFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'group') final  String group;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'recordedAt') final  DateTime? recordedAt;
@override@JsonKey(name: 'expectedDate') final  DateTime? expectedDate;

/// Create a copy of MilestoneOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneOptionCopyWith<_MilestoneOption> get copyWith => __$MilestoneOptionCopyWithImpl<_MilestoneOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneOption&&(identical(other.code, code) || other.code == code)&&(identical(other.group, group) || other.group == group)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.expectedDate, expectedDate) || other.expectedDate == expectedDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,group,title,icon,recordedAt,expectedDate);

@override
String toString() {
  return 'MilestoneOption(code: $code, group: $group, title: $title, icon: $icon, recordedAt: $recordedAt, expectedDate: $expectedDate)';
}


}

/// @nodoc
abstract mixin class _$MilestoneOptionCopyWith<$Res> implements $MilestoneOptionCopyWith<$Res> {
  factory _$MilestoneOptionCopyWith(_MilestoneOption value, $Res Function(_MilestoneOption) _then) = __$MilestoneOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'group') String group,@JsonKey(name: 'title') String title,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'recordedAt') DateTime? recordedAt,@JsonKey(name: 'expectedDate') DateTime? expectedDate
});




}
/// @nodoc
class __$MilestoneOptionCopyWithImpl<$Res>
    implements _$MilestoneOptionCopyWith<$Res> {
  __$MilestoneOptionCopyWithImpl(this._self, this._then);

  final _MilestoneOption _self;
  final $Res Function(_MilestoneOption) _then;

/// Create a copy of MilestoneOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? group = null,Object? title = null,Object? icon = freezed,Object? recordedAt = freezed,Object? expectedDate = freezed,}) {
  return _then(_MilestoneOption(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,recordedAt: freezed == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedDate: freezed == expectedDate ? _self.expectedDate : expectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
