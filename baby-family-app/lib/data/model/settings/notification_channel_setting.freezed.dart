// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_channel_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationChannelSetting {

@JsonKey(name: 'code') String get code;@JsonKey(name: 'title') String get title;@JsonKey(name: 'hint') String? get hint;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'enabled') bool get enabled;
/// Create a copy of NotificationChannelSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationChannelSettingCopyWith<NotificationChannelSetting> get copyWith => _$NotificationChannelSettingCopyWithImpl<NotificationChannelSetting>(this as NotificationChannelSetting, _$identity);

  /// Serializes this NotificationChannelSetting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationChannelSetting&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,hint,icon,enabled);

@override
String toString() {
  return 'NotificationChannelSetting(code: $code, title: $title, hint: $hint, icon: $icon, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $NotificationChannelSettingCopyWith<$Res>  {
  factory $NotificationChannelSettingCopyWith(NotificationChannelSetting value, $Res Function(NotificationChannelSetting) _then) = _$NotificationChannelSettingCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'hint') String? hint,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'enabled') bool enabled
});




}
/// @nodoc
class _$NotificationChannelSettingCopyWithImpl<$Res>
    implements $NotificationChannelSettingCopyWith<$Res> {
  _$NotificationChannelSettingCopyWithImpl(this._self, this._then);

  final NotificationChannelSetting _self;
  final $Res Function(NotificationChannelSetting) _then;

/// Create a copy of NotificationChannelSetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? title = null,Object? hint = freezed,Object? icon = freezed,Object? enabled = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationChannelSetting].
extension NotificationChannelSettingPatterns on NotificationChannelSetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationChannelSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationChannelSetting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationChannelSetting value)  $default,){
final _that = this;
switch (_that) {
case _NotificationChannelSetting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationChannelSetting value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationChannelSetting() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _NotificationChannelSetting implements NotificationChannelSetting {
  const _NotificationChannelSetting({@JsonKey(name: 'code') required this.code, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'hint') this.hint, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'enabled') this.enabled = true});
  factory _NotificationChannelSetting.fromJson(Map<String, dynamic> json) => _$NotificationChannelSettingFromJson(json);

@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'hint') final  String? hint;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'enabled') final  bool enabled;

/// Create a copy of NotificationChannelSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationChannelSettingCopyWith<_NotificationChannelSetting> get copyWith => __$NotificationChannelSettingCopyWithImpl<_NotificationChannelSetting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationChannelSettingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationChannelSetting&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,title,hint,icon,enabled);

@override
String toString() {
  return 'NotificationChannelSetting(code: $code, title: $title, hint: $hint, icon: $icon, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$NotificationChannelSettingCopyWith<$Res> implements $NotificationChannelSettingCopyWith<$Res> {
  factory _$NotificationChannelSettingCopyWith(_NotificationChannelSetting value, $Res Function(_NotificationChannelSetting) _then) = __$NotificationChannelSettingCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'code') String code,@JsonKey(name: 'title') String title,@JsonKey(name: 'hint') String? hint,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'enabled') bool enabled
});




}
/// @nodoc
class __$NotificationChannelSettingCopyWithImpl<$Res>
    implements _$NotificationChannelSettingCopyWith<$Res> {
  __$NotificationChannelSettingCopyWithImpl(this._self, this._then);

  final _NotificationChannelSetting _self;
  final $Res Function(_NotificationChannelSetting) _then;

/// Create a copy of NotificationChannelSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? title = null,Object? hint = freezed,Object? icon = freezed,Object? enabled = null,}) {
  return _then(_NotificationChannelSetting(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
