// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceInfo {

@JsonKey(name: 'deviceId') String? get deviceId;@JsonKey(name: 'platform') DeviceType? get deviceType;@JsonKey(name: 'osVersion') String? get osVersion;@JsonKey(name: 'deviceModel') String? get deviceModel;@JsonKey(name: 'appVersion') String? get appVersion;@JsonKey(name: 'manufacturer') String? get manufacturer;@JsonKey(name: 'sdkInt') int? get sdkInt;
/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<DeviceInfo> get copyWith => _$DeviceInfoCopyWithImpl<DeviceInfo>(this as DeviceInfo, _$identity);

  /// Serializes this DeviceInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceInfo&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.sdkInt, sdkInt) || other.sdkInt == sdkInt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,deviceType,osVersion,deviceModel,appVersion,manufacturer,sdkInt);

@override
String toString() {
  return 'DeviceInfo(deviceId: $deviceId, deviceType: $deviceType, osVersion: $osVersion, deviceModel: $deviceModel, appVersion: $appVersion, manufacturer: $manufacturer, sdkInt: $sdkInt)';
}


}

/// @nodoc
abstract mixin class $DeviceInfoCopyWith<$Res>  {
  factory $DeviceInfoCopyWith(DeviceInfo value, $Res Function(DeviceInfo) _then) = _$DeviceInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'deviceId') String? deviceId,@JsonKey(name: 'platform') DeviceType? deviceType,@JsonKey(name: 'osVersion') String? osVersion,@JsonKey(name: 'deviceModel') String? deviceModel,@JsonKey(name: 'appVersion') String? appVersion,@JsonKey(name: 'manufacturer') String? manufacturer,@JsonKey(name: 'sdkInt') int? sdkInt
});




}
/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._self, this._then);

  final DeviceInfo _self;
  final $Res Function(DeviceInfo) _then;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = freezed,Object? deviceType = freezed,Object? osVersion = freezed,Object? deviceModel = freezed,Object? appVersion = freezed,Object? manufacturer = freezed,Object? sdkInt = freezed,}) {
  return _then(_self.copyWith(
deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as DeviceType?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,sdkInt: freezed == sdkInt ? _self.sdkInt : sdkInt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceInfo].
extension DeviceInfoPatterns on DeviceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceInfo value)  $default,){
final _that = this;
switch (_that) {
case _DeviceInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DeviceInfo implements DeviceInfo {
  const _DeviceInfo({@JsonKey(name: 'deviceId') this.deviceId, @JsonKey(name: 'platform') this.deviceType, @JsonKey(name: 'osVersion') this.osVersion, @JsonKey(name: 'deviceModel') this.deviceModel, @JsonKey(name: 'appVersion') this.appVersion, @JsonKey(name: 'manufacturer') this.manufacturer, @JsonKey(name: 'sdkInt') this.sdkInt});
  factory _DeviceInfo.fromJson(Map<String, dynamic> json) => _$DeviceInfoFromJson(json);

@override@JsonKey(name: 'deviceId') final  String? deviceId;
@override@JsonKey(name: 'platform') final  DeviceType? deviceType;
@override@JsonKey(name: 'osVersion') final  String? osVersion;
@override@JsonKey(name: 'deviceModel') final  String? deviceModel;
@override@JsonKey(name: 'appVersion') final  String? appVersion;
@override@JsonKey(name: 'manufacturer') final  String? manufacturer;
@override@JsonKey(name: 'sdkInt') final  int? sdkInt;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceInfoCopyWith<_DeviceInfo> get copyWith => __$DeviceInfoCopyWithImpl<_DeviceInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceInfo&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.sdkInt, sdkInt) || other.sdkInt == sdkInt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,deviceType,osVersion,deviceModel,appVersion,manufacturer,sdkInt);

@override
String toString() {
  return 'DeviceInfo(deviceId: $deviceId, deviceType: $deviceType, osVersion: $osVersion, deviceModel: $deviceModel, appVersion: $appVersion, manufacturer: $manufacturer, sdkInt: $sdkInt)';
}


}

/// @nodoc
abstract mixin class _$DeviceInfoCopyWith<$Res> implements $DeviceInfoCopyWith<$Res> {
  factory _$DeviceInfoCopyWith(_DeviceInfo value, $Res Function(_DeviceInfo) _then) = __$DeviceInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'deviceId') String? deviceId,@JsonKey(name: 'platform') DeviceType? deviceType,@JsonKey(name: 'osVersion') String? osVersion,@JsonKey(name: 'deviceModel') String? deviceModel,@JsonKey(name: 'appVersion') String? appVersion,@JsonKey(name: 'manufacturer') String? manufacturer,@JsonKey(name: 'sdkInt') int? sdkInt
});




}
/// @nodoc
class __$DeviceInfoCopyWithImpl<$Res>
    implements _$DeviceInfoCopyWith<$Res> {
  __$DeviceInfoCopyWithImpl(this._self, this._then);

  final _DeviceInfo _self;
  final $Res Function(_DeviceInfo) _then;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = freezed,Object? deviceType = freezed,Object? osVersion = freezed,Object? deviceModel = freezed,Object? appVersion = freezed,Object? manufacturer = freezed,Object? sdkInt = freezed,}) {
  return _then(_DeviceInfo(
deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as DeviceType?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,sdkInt: freezed == sdkInt ? _self.sdkInt : sdkInt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
