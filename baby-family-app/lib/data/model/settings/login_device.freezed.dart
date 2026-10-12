// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginDevice {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'name') String get name;@JsonKey(name: 'kind') DeviceKind get kind;@JsonKey(name: 'location') String get location;@JsonKey(name: 'lastActiveAt') DateTime? get lastActiveAt;@JsonKey(name: 'current') bool get current;
/// Create a copy of LoginDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginDeviceCopyWith<LoginDevice> get copyWith => _$LoginDeviceCopyWithImpl<LoginDevice>(this as LoginDevice, _$identity);

  /// Serializes this LoginDevice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.location, location) || other.location == location)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,location,lastActiveAt,current);

@override
String toString() {
  return 'LoginDevice(id: $id, name: $name, kind: $kind, location: $location, lastActiveAt: $lastActiveAt, current: $current)';
}


}

/// @nodoc
abstract mixin class $LoginDeviceCopyWith<$Res>  {
  factory $LoginDeviceCopyWith(LoginDevice value, $Res Function(LoginDevice) _then) = _$LoginDeviceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'kind') DeviceKind kind,@JsonKey(name: 'location') String location,@JsonKey(name: 'lastActiveAt') DateTime? lastActiveAt,@JsonKey(name: 'current') bool current
});




}
/// @nodoc
class _$LoginDeviceCopyWithImpl<$Res>
    implements $LoginDeviceCopyWith<$Res> {
  _$LoginDeviceCopyWithImpl(this._self, this._then);

  final LoginDevice _self;
  final $Res Function(LoginDevice) _then;

/// Create a copy of LoginDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? location = null,Object? lastActiveAt = freezed,Object? current = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeviceKind,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginDevice].
extension LoginDevicePatterns on LoginDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginDevice value)  $default,){
final _that = this;
switch (_that) {
case _LoginDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginDevice value)?  $default,){
final _that = this;
switch (_that) {
case _LoginDevice() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _LoginDevice implements LoginDevice {
  const _LoginDevice({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'kind') this.kind = DeviceKind.phone, @JsonKey(name: 'location') this.location = '', @JsonKey(name: 'lastActiveAt') this.lastActiveAt, @JsonKey(name: 'current') this.current = false});
  factory _LoginDevice.fromJson(Map<String, dynamic> json) => _$LoginDeviceFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'kind') final  DeviceKind kind;
@override@JsonKey(name: 'location') final  String location;
@override@JsonKey(name: 'lastActiveAt') final  DateTime? lastActiveAt;
@override@JsonKey(name: 'current') final  bool current;

/// Create a copy of LoginDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginDeviceCopyWith<_LoginDevice> get copyWith => __$LoginDeviceCopyWithImpl<_LoginDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginDeviceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.location, location) || other.location == location)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,kind,location,lastActiveAt,current);

@override
String toString() {
  return 'LoginDevice(id: $id, name: $name, kind: $kind, location: $location, lastActiveAt: $lastActiveAt, current: $current)';
}


}

/// @nodoc
abstract mixin class _$LoginDeviceCopyWith<$Res> implements $LoginDeviceCopyWith<$Res> {
  factory _$LoginDeviceCopyWith(_LoginDevice value, $Res Function(_LoginDevice) _then) = __$LoginDeviceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'kind') DeviceKind kind,@JsonKey(name: 'location') String location,@JsonKey(name: 'lastActiveAt') DateTime? lastActiveAt,@JsonKey(name: 'current') bool current
});




}
/// @nodoc
class __$LoginDeviceCopyWithImpl<$Res>
    implements _$LoginDeviceCopyWith<$Res> {
  __$LoginDeviceCopyWithImpl(this._self, this._then);

  final _LoginDevice _self;
  final $Res Function(_LoginDevice) _then;

/// Create a copy of LoginDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? location = null,Object? lastActiveAt = freezed,Object? current = null,}) {
  return _then(_LoginDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeviceKind,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
