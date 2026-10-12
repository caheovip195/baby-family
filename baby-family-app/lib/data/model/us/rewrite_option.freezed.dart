// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rewrite_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RewriteOption {

@JsonKey(name: 'tone') RewriteTone get tone;@JsonKey(name: 'text') String get text;
/// Create a copy of RewriteOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewriteOptionCopyWith<RewriteOption> get copyWith => _$RewriteOptionCopyWithImpl<RewriteOption>(this as RewriteOption, _$identity);

  /// Serializes this RewriteOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewriteOption&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tone,text);

@override
String toString() {
  return 'RewriteOption(tone: $tone, text: $text)';
}


}

/// @nodoc
abstract mixin class $RewriteOptionCopyWith<$Res>  {
  factory $RewriteOptionCopyWith(RewriteOption value, $Res Function(RewriteOption) _then) = _$RewriteOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tone') RewriteTone tone,@JsonKey(name: 'text') String text
});




}
/// @nodoc
class _$RewriteOptionCopyWithImpl<$Res>
    implements $RewriteOptionCopyWith<$Res> {
  _$RewriteOptionCopyWithImpl(this._self, this._then);

  final RewriteOption _self;
  final $Res Function(RewriteOption) _then;

/// Create a copy of RewriteOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tone = null,Object? text = null,}) {
  return _then(_self.copyWith(
tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as RewriteTone,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RewriteOption].
extension RewriteOptionPatterns on RewriteOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RewriteOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RewriteOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RewriteOption value)  $default,){
final _that = this;
switch (_that) {
case _RewriteOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RewriteOption value)?  $default,){
final _that = this;
switch (_that) {
case _RewriteOption() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RewriteOption implements RewriteOption {
  const _RewriteOption({@JsonKey(name: 'tone') required this.tone, @JsonKey(name: 'text') required this.text});
  factory _RewriteOption.fromJson(Map<String, dynamic> json) => _$RewriteOptionFromJson(json);

@override@JsonKey(name: 'tone') final  RewriteTone tone;
@override@JsonKey(name: 'text') final  String text;

/// Create a copy of RewriteOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewriteOptionCopyWith<_RewriteOption> get copyWith => __$RewriteOptionCopyWithImpl<_RewriteOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewriteOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RewriteOption&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tone,text);

@override
String toString() {
  return 'RewriteOption(tone: $tone, text: $text)';
}


}

/// @nodoc
abstract mixin class _$RewriteOptionCopyWith<$Res> implements $RewriteOptionCopyWith<$Res> {
  factory _$RewriteOptionCopyWith(_RewriteOption value, $Res Function(_RewriteOption) _then) = __$RewriteOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tone') RewriteTone tone,@JsonKey(name: 'text') String text
});




}
/// @nodoc
class __$RewriteOptionCopyWithImpl<$Res>
    implements _$RewriteOptionCopyWith<$Res> {
  __$RewriteOptionCopyWithImpl(this._self, this._then);

  final _RewriteOption _self;
  final $Res Function(_RewriteOption) _then;

/// Create a copy of RewriteOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tone = null,Object? text = null,}) {
  return _then(_RewriteOption(
tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as RewriteTone,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
