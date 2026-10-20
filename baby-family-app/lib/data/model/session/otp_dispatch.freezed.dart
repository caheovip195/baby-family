// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_dispatch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OtpDispatch {

@JsonKey(name: 'expiresIn') int? get expiresIn;@JsonKey(name: 'resendIn') int? get resendIn;@JsonKey(name: 'channelUsed') String? get channelUsed;
/// Create a copy of OtpDispatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpDispatchCopyWith<OtpDispatch> get copyWith => _$OtpDispatchCopyWithImpl<OtpDispatch>(this as OtpDispatch, _$identity);

  /// Serializes this OtpDispatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpDispatch&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.resendIn, resendIn) || other.resendIn == resendIn)&&(identical(other.channelUsed, channelUsed) || other.channelUsed == channelUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expiresIn,resendIn,channelUsed);

@override
String toString() {
  return 'OtpDispatch(expiresIn: $expiresIn, resendIn: $resendIn, channelUsed: $channelUsed)';
}


}

/// @nodoc
abstract mixin class $OtpDispatchCopyWith<$Res>  {
  factory $OtpDispatchCopyWith(OtpDispatch value, $Res Function(OtpDispatch) _then) = _$OtpDispatchCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'expiresIn') int? expiresIn,@JsonKey(name: 'resendIn') int? resendIn,@JsonKey(name: 'channelUsed') String? channelUsed
});




}
/// @nodoc
class _$OtpDispatchCopyWithImpl<$Res>
    implements $OtpDispatchCopyWith<$Res> {
  _$OtpDispatchCopyWithImpl(this._self, this._then);

  final OtpDispatch _self;
  final $Res Function(OtpDispatch) _then;

/// Create a copy of OtpDispatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expiresIn = freezed,Object? resendIn = freezed,Object? channelUsed = freezed,}) {
  return _then(_self.copyWith(
expiresIn: freezed == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int?,resendIn: freezed == resendIn ? _self.resendIn : resendIn // ignore: cast_nullable_to_non_nullable
as int?,channelUsed: freezed == channelUsed ? _self.channelUsed : channelUsed // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpDispatch].
extension OtpDispatchPatterns on OtpDispatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpDispatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpDispatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpDispatch value)  $default,){
final _that = this;
switch (_that) {
case _OtpDispatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpDispatch value)?  $default,){
final _that = this;
switch (_that) {
case _OtpDispatch() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OtpDispatch implements OtpDispatch {
  const _OtpDispatch({@JsonKey(name: 'expiresIn') this.expiresIn, @JsonKey(name: 'resendIn') this.resendIn, @JsonKey(name: 'channelUsed') this.channelUsed});
  factory _OtpDispatch.fromJson(Map<String, dynamic> json) => _$OtpDispatchFromJson(json);

@override@JsonKey(name: 'expiresIn') final  int? expiresIn;
@override@JsonKey(name: 'resendIn') final  int? resendIn;
@override@JsonKey(name: 'channelUsed') final  String? channelUsed;

/// Create a copy of OtpDispatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpDispatchCopyWith<_OtpDispatch> get copyWith => __$OtpDispatchCopyWithImpl<_OtpDispatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtpDispatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpDispatch&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.resendIn, resendIn) || other.resendIn == resendIn)&&(identical(other.channelUsed, channelUsed) || other.channelUsed == channelUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expiresIn,resendIn,channelUsed);

@override
String toString() {
  return 'OtpDispatch(expiresIn: $expiresIn, resendIn: $resendIn, channelUsed: $channelUsed)';
}


}

/// @nodoc
abstract mixin class _$OtpDispatchCopyWith<$Res> implements $OtpDispatchCopyWith<$Res> {
  factory _$OtpDispatchCopyWith(_OtpDispatch value, $Res Function(_OtpDispatch) _then) = __$OtpDispatchCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'expiresIn') int? expiresIn,@JsonKey(name: 'resendIn') int? resendIn,@JsonKey(name: 'channelUsed') String? channelUsed
});




}
/// @nodoc
class __$OtpDispatchCopyWithImpl<$Res>
    implements _$OtpDispatchCopyWith<$Res> {
  __$OtpDispatchCopyWithImpl(this._self, this._then);

  final _OtpDispatch _self;
  final $Res Function(_OtpDispatch) _then;

/// Create a copy of OtpDispatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expiresIn = freezed,Object? resendIn = freezed,Object? channelUsed = freezed,}) {
  return _then(_OtpDispatch(
expiresIn: freezed == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int?,resendIn: freezed == resendIn ? _self.resendIn : resendIn // ignore: cast_nullable_to_non_nullable
as int?,channelUsed: freezed == channelUsed ? _self.channelUsed : channelUsed // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
