// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileSettings {

@JsonKey(name: 'name') String get name;@JsonKey(name: 'callName') String get callName;@JsonKey(name: 'avatarAsset') String? get avatarAsset;@JsonKey(name: 'signInMethods') List<SignInMethod> get signInMethods;@JsonKey(name: 'autoTimezone') bool get autoTimezone;@JsonKey(name: 'timezoneLabel') String get timezoneLabel;
/// Create a copy of ProfileSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSettingsCopyWith<ProfileSettings> get copyWith => _$ProfileSettingsCopyWithImpl<ProfileSettings>(this as ProfileSettings, _$identity);

  /// Serializes this ProfileSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSettings&&(identical(other.name, name) || other.name == name)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.avatarAsset, avatarAsset) || other.avatarAsset == avatarAsset)&&const DeepCollectionEquality().equals(other.signInMethods, signInMethods)&&(identical(other.autoTimezone, autoTimezone) || other.autoTimezone == autoTimezone)&&(identical(other.timezoneLabel, timezoneLabel) || other.timezoneLabel == timezoneLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,callName,avatarAsset,const DeepCollectionEquality().hash(signInMethods),autoTimezone,timezoneLabel);

@override
String toString() {
  return 'ProfileSettings(name: $name, callName: $callName, avatarAsset: $avatarAsset, signInMethods: $signInMethods, autoTimezone: $autoTimezone, timezoneLabel: $timezoneLabel)';
}


}

/// @nodoc
abstract mixin class $ProfileSettingsCopyWith<$Res>  {
  factory $ProfileSettingsCopyWith(ProfileSettings value, $Res Function(ProfileSettings) _then) = _$ProfileSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'callName') String callName,@JsonKey(name: 'avatarAsset') String? avatarAsset,@JsonKey(name: 'signInMethods') List<SignInMethod> signInMethods,@JsonKey(name: 'autoTimezone') bool autoTimezone,@JsonKey(name: 'timezoneLabel') String timezoneLabel
});




}
/// @nodoc
class _$ProfileSettingsCopyWithImpl<$Res>
    implements $ProfileSettingsCopyWith<$Res> {
  _$ProfileSettingsCopyWithImpl(this._self, this._then);

  final ProfileSettings _self;
  final $Res Function(ProfileSettings) _then;

/// Create a copy of ProfileSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? callName = null,Object? avatarAsset = freezed,Object? signInMethods = null,Object? autoTimezone = null,Object? timezoneLabel = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,callName: null == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String,avatarAsset: freezed == avatarAsset ? _self.avatarAsset : avatarAsset // ignore: cast_nullable_to_non_nullable
as String?,signInMethods: null == signInMethods ? _self.signInMethods : signInMethods // ignore: cast_nullable_to_non_nullable
as List<SignInMethod>,autoTimezone: null == autoTimezone ? _self.autoTimezone : autoTimezone // ignore: cast_nullable_to_non_nullable
as bool,timezoneLabel: null == timezoneLabel ? _self.timezoneLabel : timezoneLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileSettings].
extension ProfileSettingsPatterns on ProfileSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileSettings value)  $default,){
final _that = this;
switch (_that) {
case _ProfileSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ProfileSettings implements ProfileSettings {
  const _ProfileSettings({@JsonKey(name: 'name') this.name = '', @JsonKey(name: 'callName') this.callName = '', @JsonKey(name: 'avatarAsset') this.avatarAsset, @JsonKey(name: 'signInMethods') final  List<SignInMethod> signInMethods = const [], @JsonKey(name: 'autoTimezone') this.autoTimezone = true, @JsonKey(name: 'timezoneLabel') this.timezoneLabel = ''}): _signInMethods = signInMethods;
  factory _ProfileSettings.fromJson(Map<String, dynamic> json) => _$ProfileSettingsFromJson(json);

@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'callName') final  String callName;
@override@JsonKey(name: 'avatarAsset') final  String? avatarAsset;
 final  List<SignInMethod> _signInMethods;
@override@JsonKey(name: 'signInMethods') List<SignInMethod> get signInMethods {
  if (_signInMethods is EqualUnmodifiableListView) return _signInMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_signInMethods);
}

@override@JsonKey(name: 'autoTimezone') final  bool autoTimezone;
@override@JsonKey(name: 'timezoneLabel') final  String timezoneLabel;

/// Create a copy of ProfileSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileSettingsCopyWith<_ProfileSettings> get copyWith => __$ProfileSettingsCopyWithImpl<_ProfileSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSettings&&(identical(other.name, name) || other.name == name)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.avatarAsset, avatarAsset) || other.avatarAsset == avatarAsset)&&const DeepCollectionEquality().equals(other._signInMethods, _signInMethods)&&(identical(other.autoTimezone, autoTimezone) || other.autoTimezone == autoTimezone)&&(identical(other.timezoneLabel, timezoneLabel) || other.timezoneLabel == timezoneLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,callName,avatarAsset,const DeepCollectionEquality().hash(_signInMethods),autoTimezone,timezoneLabel);

@override
String toString() {
  return 'ProfileSettings(name: $name, callName: $callName, avatarAsset: $avatarAsset, signInMethods: $signInMethods, autoTimezone: $autoTimezone, timezoneLabel: $timezoneLabel)';
}


}

/// @nodoc
abstract mixin class _$ProfileSettingsCopyWith<$Res> implements $ProfileSettingsCopyWith<$Res> {
  factory _$ProfileSettingsCopyWith(_ProfileSettings value, $Res Function(_ProfileSettings) _then) = __$ProfileSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'callName') String callName,@JsonKey(name: 'avatarAsset') String? avatarAsset,@JsonKey(name: 'signInMethods') List<SignInMethod> signInMethods,@JsonKey(name: 'autoTimezone') bool autoTimezone,@JsonKey(name: 'timezoneLabel') String timezoneLabel
});




}
/// @nodoc
class __$ProfileSettingsCopyWithImpl<$Res>
    implements _$ProfileSettingsCopyWith<$Res> {
  __$ProfileSettingsCopyWithImpl(this._self, this._then);

  final _ProfileSettings _self;
  final $Res Function(_ProfileSettings) _then;

/// Create a copy of ProfileSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? callName = null,Object? avatarAsset = freezed,Object? signInMethods = null,Object? autoTimezone = null,Object? timezoneLabel = null,}) {
  return _then(_ProfileSettings(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,callName: null == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String,avatarAsset: freezed == avatarAsset ? _self.avatarAsset : avatarAsset // ignore: cast_nullable_to_non_nullable
as String?,signInMethods: null == signInMethods ? _self._signInMethods : signInMethods // ignore: cast_nullable_to_non_nullable
as List<SignInMethod>,autoTimezone: null == autoTimezone ? _self.autoTimezone : autoTimezone // ignore: cast_nullable_to_non_nullable
as bool,timezoneLabel: null == timezoneLabel ? _self.timezoneLabel : timezoneLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
