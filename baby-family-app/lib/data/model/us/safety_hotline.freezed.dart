// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'safety_hotline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SafetyHotline {

@JsonKey(name: 'number') String get number;@JsonKey(name: 'title') String get title;@JsonKey(name: 'hint') String? get hint;
/// Create a copy of SafetyHotline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SafetyHotlineCopyWith<SafetyHotline> get copyWith => _$SafetyHotlineCopyWithImpl<SafetyHotline>(this as SafetyHotline, _$identity);

  /// Serializes this SafetyHotline to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SafetyHotline&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.hint, hint) || other.hint == hint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,title,hint);

@override
String toString() {
  return 'SafetyHotline(number: $number, title: $title, hint: $hint)';
}


}

/// @nodoc
abstract mixin class $SafetyHotlineCopyWith<$Res>  {
  factory $SafetyHotlineCopyWith(SafetyHotline value, $Res Function(SafetyHotline) _then) = _$SafetyHotlineCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'number') String number,@JsonKey(name: 'title') String title,@JsonKey(name: 'hint') String? hint
});




}
/// @nodoc
class _$SafetyHotlineCopyWithImpl<$Res>
    implements $SafetyHotlineCopyWith<$Res> {
  _$SafetyHotlineCopyWithImpl(this._self, this._then);

  final SafetyHotline _self;
  final $Res Function(SafetyHotline) _then;

/// Create a copy of SafetyHotline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? title = null,Object? hint = freezed,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SafetyHotline].
extension SafetyHotlinePatterns on SafetyHotline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SafetyHotline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SafetyHotline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SafetyHotline value)  $default,){
final _that = this;
switch (_that) {
case _SafetyHotline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SafetyHotline value)?  $default,){
final _that = this;
switch (_that) {
case _SafetyHotline() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SafetyHotline implements SafetyHotline {
  const _SafetyHotline({@JsonKey(name: 'number') required this.number, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'hint') this.hint});
  factory _SafetyHotline.fromJson(Map<String, dynamic> json) => _$SafetyHotlineFromJson(json);

@override@JsonKey(name: 'number') final  String number;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'hint') final  String? hint;

/// Create a copy of SafetyHotline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SafetyHotlineCopyWith<_SafetyHotline> get copyWith => __$SafetyHotlineCopyWithImpl<_SafetyHotline>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SafetyHotlineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SafetyHotline&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.hint, hint) || other.hint == hint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,title,hint);

@override
String toString() {
  return 'SafetyHotline(number: $number, title: $title, hint: $hint)';
}


}

/// @nodoc
abstract mixin class _$SafetyHotlineCopyWith<$Res> implements $SafetyHotlineCopyWith<$Res> {
  factory _$SafetyHotlineCopyWith(_SafetyHotline value, $Res Function(_SafetyHotline) _then) = __$SafetyHotlineCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'number') String number,@JsonKey(name: 'title') String title,@JsonKey(name: 'hint') String? hint
});




}
/// @nodoc
class __$SafetyHotlineCopyWithImpl<$Res>
    implements _$SafetyHotlineCopyWith<$Res> {
  __$SafetyHotlineCopyWithImpl(this._self, this._then);

  final _SafetyHotline _self;
  final $Res Function(_SafetyHotline) _then;

/// Create a copy of SafetyHotline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? title = null,Object? hint = freezed,}) {
  return _then(_SafetyHotline(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
