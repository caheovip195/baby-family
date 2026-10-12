// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BridgeOption {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'title') String get title;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'tag') String? get tag;
/// Create a copy of BridgeOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BridgeOptionCopyWith<BridgeOption> get copyWith => _$BridgeOptionCopyWithImpl<BridgeOption>(this as BridgeOption, _$identity);

  /// Serializes this BridgeOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BridgeOption&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,icon,tag);

@override
String toString() {
  return 'BridgeOption(code: $code, title: $title, icon: $icon, tag: $tag)';
}


}

/// @nodoc
abstract mixin class $BridgeOptionCopyWith<$Res>  {
  factory $BridgeOptionCopyWith(BridgeOption value, $Res Function(BridgeOption) _then) = _$BridgeOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'tag') String? tag
});




}
/// @nodoc
class _$BridgeOptionCopyWithImpl<$Res>
    implements $BridgeOptionCopyWith<$Res> {
  _$BridgeOptionCopyWithImpl(this._self, this._then);

  final BridgeOption _self;
  final $Res Function(BridgeOption) _then;

/// Create a copy of BridgeOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? title = null,Object? icon = freezed,Object? tag = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BridgeOption].
extension BridgeOptionPatterns on BridgeOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BridgeOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BridgeOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BridgeOption value)  $default,){
final _that = this;
switch (_that) {
case _BridgeOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BridgeOption value)?  $default,){
final _that = this;
switch (_that) {
case _BridgeOption() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BridgeOption implements BridgeOption {
  const _BridgeOption({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'tag') this.tag});
  factory _BridgeOption.fromJson(Map<String, dynamic> json) => _$BridgeOptionFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'tag') final  String? tag;

/// Create a copy of BridgeOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BridgeOptionCopyWith<_BridgeOption> get copyWith => __$BridgeOptionCopyWithImpl<_BridgeOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BridgeOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BridgeOption&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,icon,tag);

@override
String toString() {
  return 'BridgeOption(code: $code, title: $title, icon: $icon, tag: $tag)';
}


}

/// @nodoc
abstract mixin class _$BridgeOptionCopyWith<$Res> implements $BridgeOptionCopyWith<$Res> {
  factory _$BridgeOptionCopyWith(_BridgeOption value, $Res Function(_BridgeOption) _then) = __$BridgeOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'tag') String? tag
});




}
/// @nodoc
class __$BridgeOptionCopyWithImpl<$Res>
    implements _$BridgeOptionCopyWith<$Res> {
  __$BridgeOptionCopyWithImpl(this._self, this._then);

  final _BridgeOption _self;
  final $Res Function(_BridgeOption) _then;

/// Create a copy of BridgeOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? title = null,Object? icon = freezed,Object? tag = freezed,}) {
  return _then(_BridgeOption(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
