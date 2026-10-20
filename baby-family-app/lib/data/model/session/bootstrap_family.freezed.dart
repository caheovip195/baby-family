// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bootstrap_family.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BootstrapFamily {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'timezone') String? get timezone;@JsonKey(name: 'activatedAt') DateTime? get activatedAt;
/// Create a copy of BootstrapFamily
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BootstrapFamilyCopyWith<BootstrapFamily> get copyWith => _$BootstrapFamilyCopyWithImpl<BootstrapFamily>(this as BootstrapFamily, _$identity);

  /// Serializes this BootstrapFamily to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BootstrapFamily&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,timezone,activatedAt);

@override
String toString() {
  return 'BootstrapFamily(id: $id, name: $name, status: $status, timezone: $timezone, activatedAt: $activatedAt)';
}


}

/// @nodoc
abstract mixin class $BootstrapFamilyCopyWith<$Res>  {
  factory $BootstrapFamilyCopyWith(BootstrapFamily value, $Res Function(BootstrapFamily) _then) = _$BootstrapFamilyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'status') String? status,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'activatedAt') DateTime? activatedAt
});




}
/// @nodoc
class _$BootstrapFamilyCopyWithImpl<$Res>
    implements $BootstrapFamilyCopyWith<$Res> {
  _$BootstrapFamilyCopyWithImpl(this._self, this._then);

  final BootstrapFamily _self;
  final $Res Function(BootstrapFamily) _then;

/// Create a copy of BootstrapFamily
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? status = freezed,Object? timezone = freezed,Object? activatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BootstrapFamily].
extension BootstrapFamilyPatterns on BootstrapFamily {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BootstrapFamily value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BootstrapFamily() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BootstrapFamily value)  $default,){
final _that = this;
switch (_that) {
case _BootstrapFamily():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BootstrapFamily value)?  $default,){
final _that = this;
switch (_that) {
case _BootstrapFamily() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BootstrapFamily implements BootstrapFamily {
  const _BootstrapFamily({@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name, @JsonKey(name: 'status') this.status, @JsonKey(name: 'timezone') this.timezone, @JsonKey(name: 'activatedAt') this.activatedAt});
  factory _BootstrapFamily.fromJson(Map<String, dynamic> json) => _$BootstrapFamilyFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'timezone') final  String? timezone;
@override@JsonKey(name: 'activatedAt') final  DateTime? activatedAt;

/// Create a copy of BootstrapFamily
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BootstrapFamilyCopyWith<_BootstrapFamily> get copyWith => __$BootstrapFamilyCopyWithImpl<_BootstrapFamily>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BootstrapFamilyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BootstrapFamily&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,timezone,activatedAt);

@override
String toString() {
  return 'BootstrapFamily(id: $id, name: $name, status: $status, timezone: $timezone, activatedAt: $activatedAt)';
}


}

/// @nodoc
abstract mixin class _$BootstrapFamilyCopyWith<$Res> implements $BootstrapFamilyCopyWith<$Res> {
  factory _$BootstrapFamilyCopyWith(_BootstrapFamily value, $Res Function(_BootstrapFamily) _then) = __$BootstrapFamilyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'status') String? status,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'activatedAt') DateTime? activatedAt
});




}
/// @nodoc
class __$BootstrapFamilyCopyWithImpl<$Res>
    implements _$BootstrapFamilyCopyWith<$Res> {
  __$BootstrapFamilyCopyWithImpl(this._self, this._then);

  final _BootstrapFamily _self;
  final $Res Function(_BootstrapFamily) _then;

/// Create a copy of BootstrapFamily
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? status = freezed,Object? timezone = freezed,Object? activatedAt = freezed,}) {
  return _then(_BootstrapFamily(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
