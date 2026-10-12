// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SecuritySettings {

@JsonKey(name: 'faceIdLock') bool get faceIdLock;@JsonKey(name: 'pinSet') bool get pinSet;@JsonKey(name: 'devices') List<LoginDevice> get devices;
/// Create a copy of SecuritySettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecuritySettingsCopyWith<SecuritySettings> get copyWith => _$SecuritySettingsCopyWithImpl<SecuritySettings>(this as SecuritySettings, _$identity);

  /// Serializes this SecuritySettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecuritySettings&&(identical(other.faceIdLock, faceIdLock) || other.faceIdLock == faceIdLock)&&(identical(other.pinSet, pinSet) || other.pinSet == pinSet)&&const DeepCollectionEquality().equals(other.devices, devices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,faceIdLock,pinSet,const DeepCollectionEquality().hash(devices));

@override
String toString() {
  return 'SecuritySettings(faceIdLock: $faceIdLock, pinSet: $pinSet, devices: $devices)';
}


}

/// @nodoc
abstract mixin class $SecuritySettingsCopyWith<$Res>  {
  factory $SecuritySettingsCopyWith(SecuritySettings value, $Res Function(SecuritySettings) _then) = _$SecuritySettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'faceIdLock') bool faceIdLock,@JsonKey(name: 'pinSet') bool pinSet,@JsonKey(name: 'devices') List<LoginDevice> devices
});




}
/// @nodoc
class _$SecuritySettingsCopyWithImpl<$Res>
    implements $SecuritySettingsCopyWith<$Res> {
  _$SecuritySettingsCopyWithImpl(this._self, this._then);

  final SecuritySettings _self;
  final $Res Function(SecuritySettings) _then;

/// Create a copy of SecuritySettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? faceIdLock = null,Object? pinSet = null,Object? devices = null,}) {
  return _then(_self.copyWith(
faceIdLock: null == faceIdLock ? _self.faceIdLock : faceIdLock // ignore: cast_nullable_to_non_nullable
as bool,pinSet: null == pinSet ? _self.pinSet : pinSet // ignore: cast_nullable_to_non_nullable
as bool,devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<LoginDevice>,
  ));
}

}


/// Adds pattern-matching-related methods to [SecuritySettings].
extension SecuritySettingsPatterns on SecuritySettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecuritySettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecuritySettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecuritySettings value)  $default,){
final _that = this;
switch (_that) {
case _SecuritySettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecuritySettings value)?  $default,){
final _that = this;
switch (_that) {
case _SecuritySettings() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SecuritySettings implements SecuritySettings {
  const _SecuritySettings({@JsonKey(name: 'faceIdLock') this.faceIdLock = true, @JsonKey(name: 'pinSet') this.pinSet = true, @JsonKey(name: 'devices') final  List<LoginDevice> devices = const []}): _devices = devices;
  factory _SecuritySettings.fromJson(Map<String, dynamic> json) => _$SecuritySettingsFromJson(json);

@override@JsonKey(name: 'faceIdLock') final  bool faceIdLock;
@override@JsonKey(name: 'pinSet') final  bool pinSet;
 final  List<LoginDevice> _devices;
@override@JsonKey(name: 'devices') List<LoginDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}


/// Create a copy of SecuritySettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecuritySettingsCopyWith<_SecuritySettings> get copyWith => __$SecuritySettingsCopyWithImpl<_SecuritySettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SecuritySettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecuritySettings&&(identical(other.faceIdLock, faceIdLock) || other.faceIdLock == faceIdLock)&&(identical(other.pinSet, pinSet) || other.pinSet == pinSet)&&const DeepCollectionEquality().equals(other._devices, _devices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,faceIdLock,pinSet,const DeepCollectionEquality().hash(_devices));

@override
String toString() {
  return 'SecuritySettings(faceIdLock: $faceIdLock, pinSet: $pinSet, devices: $devices)';
}


}

/// @nodoc
abstract mixin class _$SecuritySettingsCopyWith<$Res> implements $SecuritySettingsCopyWith<$Res> {
  factory _$SecuritySettingsCopyWith(_SecuritySettings value, $Res Function(_SecuritySettings) _then) = __$SecuritySettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'faceIdLock') bool faceIdLock,@JsonKey(name: 'pinSet') bool pinSet,@JsonKey(name: 'devices') List<LoginDevice> devices
});




}
/// @nodoc
class __$SecuritySettingsCopyWithImpl<$Res>
    implements _$SecuritySettingsCopyWith<$Res> {
  __$SecuritySettingsCopyWithImpl(this._self, this._then);

  final _SecuritySettings _self;
  final $Res Function(_SecuritySettings) _then;

/// Create a copy of SecuritySettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? faceIdLock = null,Object? pinSet = null,Object? devices = null,}) {
  return _then(_SecuritySettings(
faceIdLock: null == faceIdLock ? _self.faceIdLock : faceIdLock // ignore: cast_nullable_to_non_nullable
as bool,pinSet: null == pinSet ? _self.pinSet : pinSet // ignore: cast_nullable_to_non_nullable
as bool,devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<LoginDevice>,
  ));
}


}

// dart format on
