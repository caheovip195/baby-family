// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_feature_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiFeatureSetting {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'title') String get title;@JsonKey(name: 'sends') String? get sends;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'enabled') bool get enabled;
/// Create a copy of AiFeatureSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiFeatureSettingCopyWith<AiFeatureSetting> get copyWith => _$AiFeatureSettingCopyWithImpl<AiFeatureSetting>(this as AiFeatureSetting, _$identity);

  /// Serializes this AiFeatureSetting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiFeatureSetting&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.sends, sends) || other.sends == sends)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,sends,icon,enabled);

@override
String toString() {
  return 'AiFeatureSetting(code: $code, title: $title, sends: $sends, icon: $icon, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $AiFeatureSettingCopyWith<$Res>  {
  factory $AiFeatureSettingCopyWith(AiFeatureSetting value, $Res Function(AiFeatureSetting) _then) = _$AiFeatureSettingCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'sends') String? sends,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'enabled') bool enabled
});




}
/// @nodoc
class _$AiFeatureSettingCopyWithImpl<$Res>
    implements $AiFeatureSettingCopyWith<$Res> {
  _$AiFeatureSettingCopyWithImpl(this._self, this._then);

  final AiFeatureSetting _self;
  final $Res Function(AiFeatureSetting) _then;

/// Create a copy of AiFeatureSetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? title = null,Object? sends = freezed,Object? icon = freezed,Object? enabled = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sends: freezed == sends ? _self.sends : sends // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiFeatureSetting].
extension AiFeatureSettingPatterns on AiFeatureSetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiFeatureSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiFeatureSetting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiFeatureSetting value)  $default,){
final _that = this;
switch (_that) {
case _AiFeatureSetting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiFeatureSetting value)?  $default,){
final _that = this;
switch (_that) {
case _AiFeatureSetting() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AiFeatureSetting implements AiFeatureSetting {
  const _AiFeatureSetting({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'sends') this.sends, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'enabled') this.enabled = true});
  factory _AiFeatureSetting.fromJson(Map<String, dynamic> json) => _$AiFeatureSettingFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'sends') final  String? sends;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'enabled') final  bool enabled;

/// Create a copy of AiFeatureSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiFeatureSettingCopyWith<_AiFeatureSetting> get copyWith => __$AiFeatureSettingCopyWithImpl<_AiFeatureSetting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiFeatureSettingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiFeatureSetting&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.sends, sends) || other.sends == sends)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,sends,icon,enabled);

@override
String toString() {
  return 'AiFeatureSetting(code: $code, title: $title, sends: $sends, icon: $icon, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$AiFeatureSettingCopyWith<$Res> implements $AiFeatureSettingCopyWith<$Res> {
  factory _$AiFeatureSettingCopyWith(_AiFeatureSetting value, $Res Function(_AiFeatureSetting) _then) = __$AiFeatureSettingCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'sends') String? sends,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'enabled') bool enabled
});




}
/// @nodoc
class __$AiFeatureSettingCopyWithImpl<$Res>
    implements _$AiFeatureSettingCopyWith<$Res> {
  __$AiFeatureSettingCopyWithImpl(this._self, this._then);

  final _AiFeatureSetting _self;
  final $Res Function(_AiFeatureSetting) _then;

/// Create a copy of AiFeatureSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? title = null,Object? sends = freezed,Object? icon = freezed,Object? enabled = null,}) {
  return _then(_AiFeatureSetting(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sends: freezed == sends ? _self.sends : sends // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
