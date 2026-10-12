// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSettings {

@JsonKey(name: 'channels') List<NotificationChannelSetting> get channels;@JsonKey(name: 'quietHours') bool get quietHours;@JsonKey(name: 'quietFrom') String get quietFrom;@JsonKey(name: 'quietTo') String get quietTo;@JsonKey(name: 'urgentBypassQuiet') bool get urgentBypassQuiet;@JsonKey(name: 'hideOnLockScreen') bool get hideOnLockScreen;@JsonKey(name: 'relativesDigestTime') String get relativesDigestTime;@JsonKey(name: 'mutedPeople') int get mutedPeople;
/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSettingsCopyWith<NotificationSettings> get copyWith => _$NotificationSettingsCopyWithImpl<NotificationSettings>(this as NotificationSettings, _$identity);

  /// Serializes this NotificationSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSettings&&const DeepCollectionEquality().equals(other.channels, channels)&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours)&&(identical(other.quietFrom, quietFrom) || other.quietFrom == quietFrom)&&(identical(other.quietTo, quietTo) || other.quietTo == quietTo)&&(identical(other.urgentBypassQuiet, urgentBypassQuiet) || other.urgentBypassQuiet == urgentBypassQuiet)&&(identical(other.hideOnLockScreen, hideOnLockScreen) || other.hideOnLockScreen == hideOnLockScreen)&&(identical(other.relativesDigestTime, relativesDigestTime) || other.relativesDigestTime == relativesDigestTime)&&(identical(other.mutedPeople, mutedPeople) || other.mutedPeople == mutedPeople));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(channels),quietHours,quietFrom,quietTo,urgentBypassQuiet,hideOnLockScreen,relativesDigestTime,mutedPeople);

@override
String toString() {
  return 'NotificationSettings(channels: $channels, quietHours: $quietHours, quietFrom: $quietFrom, quietTo: $quietTo, urgentBypassQuiet: $urgentBypassQuiet, hideOnLockScreen: $hideOnLockScreen, relativesDigestTime: $relativesDigestTime, mutedPeople: $mutedPeople)';
}


}

/// @nodoc
abstract mixin class $NotificationSettingsCopyWith<$Res>  {
  factory $NotificationSettingsCopyWith(NotificationSettings value, $Res Function(NotificationSettings) _then) = _$NotificationSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'channels') List<NotificationChannelSetting> channels,@JsonKey(name: 'quietHours') bool quietHours,@JsonKey(name: 'quietFrom') String quietFrom,@JsonKey(name: 'quietTo') String quietTo,@JsonKey(name: 'urgentBypassQuiet') bool urgentBypassQuiet,@JsonKey(name: 'hideOnLockScreen') bool hideOnLockScreen,@JsonKey(name: 'relativesDigestTime') String relativesDigestTime,@JsonKey(name: 'mutedPeople') int mutedPeople
});




}
/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._self, this._then);

  final NotificationSettings _self;
  final $Res Function(NotificationSettings) _then;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channels = null,Object? quietHours = null,Object? quietFrom = null,Object? quietTo = null,Object? urgentBypassQuiet = null,Object? hideOnLockScreen = null,Object? relativesDigestTime = null,Object? mutedPeople = null,}) {
  return _then(_self.copyWith(
channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<NotificationChannelSetting>,quietHours: null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as bool,quietFrom: null == quietFrom ? _self.quietFrom : quietFrom // ignore: cast_nullable_to_non_nullable
as String,quietTo: null == quietTo ? _self.quietTo : quietTo // ignore: cast_nullable_to_non_nullable
as String,urgentBypassQuiet: null == urgentBypassQuiet ? _self.urgentBypassQuiet : urgentBypassQuiet // ignore: cast_nullable_to_non_nullable
as bool,hideOnLockScreen: null == hideOnLockScreen ? _self.hideOnLockScreen : hideOnLockScreen // ignore: cast_nullable_to_non_nullable
as bool,relativesDigestTime: null == relativesDigestTime ? _self.relativesDigestTime : relativesDigestTime // ignore: cast_nullable_to_non_nullable
as String,mutedPeople: null == mutedPeople ? _self.mutedPeople : mutedPeople // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationSettings].
extension NotificationSettingsPatterns on NotificationSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSettings value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSettings value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _NotificationSettings implements NotificationSettings {
  const _NotificationSettings({@JsonKey(name: 'channels') final  List<NotificationChannelSetting> channels = const [], @JsonKey(name: 'quietHours') this.quietHours = true, @JsonKey(name: 'quietFrom') this.quietFrom = '22:00', @JsonKey(name: 'quietTo') this.quietTo = '06:30', @JsonKey(name: 'urgentBypassQuiet') this.urgentBypassQuiet = false, @JsonKey(name: 'hideOnLockScreen') this.hideOnLockScreen = true, @JsonKey(name: 'relativesDigestTime') this.relativesDigestTime = '19:00', @JsonKey(name: 'mutedPeople') this.mutedPeople = 0}): _channels = channels;
  factory _NotificationSettings.fromJson(Map<String, dynamic> json) => _$NotificationSettingsFromJson(json);

 final  List<NotificationChannelSetting> _channels;
@override@JsonKey(name: 'channels') List<NotificationChannelSetting> get channels {
  if (_channels is EqualUnmodifiableListView) return _channels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channels);
}

@override@JsonKey(name: 'quietHours') final  bool quietHours;
@override@JsonKey(name: 'quietFrom') final  String quietFrom;
@override@JsonKey(name: 'quietTo') final  String quietTo;
@override@JsonKey(name: 'urgentBypassQuiet') final  bool urgentBypassQuiet;
@override@JsonKey(name: 'hideOnLockScreen') final  bool hideOnLockScreen;
@override@JsonKey(name: 'relativesDigestTime') final  String relativesDigestTime;
@override@JsonKey(name: 'mutedPeople') final  int mutedPeople;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSettingsCopyWith<_NotificationSettings> get copyWith => __$NotificationSettingsCopyWithImpl<_NotificationSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSettings&&const DeepCollectionEquality().equals(other._channels, _channels)&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours)&&(identical(other.quietFrom, quietFrom) || other.quietFrom == quietFrom)&&(identical(other.quietTo, quietTo) || other.quietTo == quietTo)&&(identical(other.urgentBypassQuiet, urgentBypassQuiet) || other.urgentBypassQuiet == urgentBypassQuiet)&&(identical(other.hideOnLockScreen, hideOnLockScreen) || other.hideOnLockScreen == hideOnLockScreen)&&(identical(other.relativesDigestTime, relativesDigestTime) || other.relativesDigestTime == relativesDigestTime)&&(identical(other.mutedPeople, mutedPeople) || other.mutedPeople == mutedPeople));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_channels),quietHours,quietFrom,quietTo,urgentBypassQuiet,hideOnLockScreen,relativesDigestTime,mutedPeople);

@override
String toString() {
  return 'NotificationSettings(channels: $channels, quietHours: $quietHours, quietFrom: $quietFrom, quietTo: $quietTo, urgentBypassQuiet: $urgentBypassQuiet, hideOnLockScreen: $hideOnLockScreen, relativesDigestTime: $relativesDigestTime, mutedPeople: $mutedPeople)';
}


}

/// @nodoc
abstract mixin class _$NotificationSettingsCopyWith<$Res> implements $NotificationSettingsCopyWith<$Res> {
  factory _$NotificationSettingsCopyWith(_NotificationSettings value, $Res Function(_NotificationSettings) _then) = __$NotificationSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'channels') List<NotificationChannelSetting> channels,@JsonKey(name: 'quietHours') bool quietHours,@JsonKey(name: 'quietFrom') String quietFrom,@JsonKey(name: 'quietTo') String quietTo,@JsonKey(name: 'urgentBypassQuiet') bool urgentBypassQuiet,@JsonKey(name: 'hideOnLockScreen') bool hideOnLockScreen,@JsonKey(name: 'relativesDigestTime') String relativesDigestTime,@JsonKey(name: 'mutedPeople') int mutedPeople
});




}
/// @nodoc
class __$NotificationSettingsCopyWithImpl<$Res>
    implements _$NotificationSettingsCopyWith<$Res> {
  __$NotificationSettingsCopyWithImpl(this._self, this._then);

  final _NotificationSettings _self;
  final $Res Function(_NotificationSettings) _then;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channels = null,Object? quietHours = null,Object? quietFrom = null,Object? quietTo = null,Object? urgentBypassQuiet = null,Object? hideOnLockScreen = null,Object? relativesDigestTime = null,Object? mutedPeople = null,}) {
  return _then(_NotificationSettings(
channels: null == channels ? _self._channels : channels // ignore: cast_nullable_to_non_nullable
as List<NotificationChannelSetting>,quietHours: null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as bool,quietFrom: null == quietFrom ? _self.quietFrom : quietFrom // ignore: cast_nullable_to_non_nullable
as String,quietTo: null == quietTo ? _self.quietTo : quietTo // ignore: cast_nullable_to_non_nullable
as String,urgentBypassQuiet: null == urgentBypassQuiet ? _self.urgentBypassQuiet : urgentBypassQuiet // ignore: cast_nullable_to_non_nullable
as bool,hideOnLockScreen: null == hideOnLockScreen ? _self.hideOnLockScreen : hideOnLockScreen // ignore: cast_nullable_to_non_nullable
as bool,relativesDigestTime: null == relativesDigestTime ? _self.relativesDigestTime : relativesDigestTime // ignore: cast_nullable_to_non_nullable
as String,mutedPeople: null == mutedPeople ? _self.mutedPeople : mutedPeople // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
