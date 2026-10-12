// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_reason.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportReason {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'title') String get title;@JsonKey(name: 'hint') String? get hint;@JsonKey(name: 'note') String? get note;@JsonKey(name: 'priority') bool get priority;
/// Create a copy of ReportReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportReasonCopyWith<ReportReason> get copyWith => _$ReportReasonCopyWithImpl<ReportReason>(this as ReportReason, _$identity);

  /// Serializes this ReportReason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportReason&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.note, note) || other.note == note)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,hint,note,priority);

@override
String toString() {
  return 'ReportReason(code: $code, title: $title, hint: $hint, note: $note, priority: $priority)';
}


}

/// @nodoc
abstract mixin class $ReportReasonCopyWith<$Res>  {
  factory $ReportReasonCopyWith(ReportReason value, $Res Function(ReportReason) _then) = _$ReportReasonCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'hint') String? hint,@JsonKey(name: 'note') String? note,@JsonKey(name: 'priority') bool priority
});




}
/// @nodoc
class _$ReportReasonCopyWithImpl<$Res>
    implements $ReportReasonCopyWith<$Res> {
  _$ReportReasonCopyWithImpl(this._self, this._then);

  final ReportReason _self;
  final $Res Function(ReportReason) _then;

/// Create a copy of ReportReason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? title = null,Object? hint = freezed,Object? note = freezed,Object? priority = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportReason].
extension ReportReasonPatterns on ReportReason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportReason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportReason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportReason value)  $default,){
final _that = this;
switch (_that) {
case _ReportReason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportReason value)?  $default,){
final _that = this;
switch (_that) {
case _ReportReason() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReportReason implements ReportReason {
  const _ReportReason({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'hint') this.hint, @JsonKey(name: 'note') this.note, @JsonKey(name: 'priority') this.priority = false});
  factory _ReportReason.fromJson(Map<String, dynamic> json) => _$ReportReasonFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'hint') final  String? hint;
@override@JsonKey(name: 'note') final  String? note;
@override@JsonKey(name: 'priority') final  bool priority;

/// Create a copy of ReportReason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportReasonCopyWith<_ReportReason> get copyWith => __$ReportReasonCopyWithImpl<_ReportReason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportReasonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportReason&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.note, note) || other.note == note)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,hint,note,priority);

@override
String toString() {
  return 'ReportReason(code: $code, title: $title, hint: $hint, note: $note, priority: $priority)';
}


}

/// @nodoc
abstract mixin class _$ReportReasonCopyWith<$Res> implements $ReportReasonCopyWith<$Res> {
  factory _$ReportReasonCopyWith(_ReportReason value, $Res Function(_ReportReason) _then) = __$ReportReasonCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'hint') String? hint,@JsonKey(name: 'note') String? note,@JsonKey(name: 'priority') bool priority
});




}
/// @nodoc
class __$ReportReasonCopyWithImpl<$Res>
    implements _$ReportReasonCopyWith<$Res> {
  __$ReportReasonCopyWithImpl(this._self, this._then);

  final _ReportReason _self;
  final $Res Function(_ReportReason) _then;

/// Create a copy of ReportReason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? title = null,Object? hint = freezed,Object? note = freezed,Object? priority = null,}) {
  return _then(_ReportReason(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
