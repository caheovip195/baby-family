// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_method.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignInMethod {

@JsonKey(name: 'method') AuthMethod get method;@JsonKey(name: 'linked') bool get linked;@JsonKey(name: 'maskedAccount') String? get maskedAccount;
/// Create a copy of SignInMethod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInMethodCopyWith<SignInMethod> get copyWith => _$SignInMethodCopyWithImpl<SignInMethod>(this as SignInMethod, _$identity);

  /// Serializes this SignInMethod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInMethod&&(identical(other.method, method) || other.method == method)&&(identical(other.linked, linked) || other.linked == linked)&&(identical(other.maskedAccount, maskedAccount) || other.maskedAccount == maskedAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,linked,maskedAccount);

@override
String toString() {
  return 'SignInMethod(method: $method, linked: $linked, maskedAccount: $maskedAccount)';
}


}

/// @nodoc
abstract mixin class $SignInMethodCopyWith<$Res>  {
  factory $SignInMethodCopyWith(SignInMethod value, $Res Function(SignInMethod) _then) = _$SignInMethodCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'method') AuthMethod method,@JsonKey(name: 'linked') bool linked,@JsonKey(name: 'maskedAccount') String? maskedAccount
});




}
/// @nodoc
class _$SignInMethodCopyWithImpl<$Res>
    implements $SignInMethodCopyWith<$Res> {
  _$SignInMethodCopyWithImpl(this._self, this._then);

  final SignInMethod _self;
  final $Res Function(SignInMethod) _then;

/// Create a copy of SignInMethod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? linked = null,Object? maskedAccount = freezed,}) {
  return _then(_self.copyWith(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as AuthMethod,linked: null == linked ? _self.linked : linked // ignore: cast_nullable_to_non_nullable
as bool,maskedAccount: freezed == maskedAccount ? _self.maskedAccount : maskedAccount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SignInMethod].
extension SignInMethodPatterns on SignInMethod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignInMethod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignInMethod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignInMethod value)  $default,){
final _that = this;
switch (_that) {
case _SignInMethod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignInMethod value)?  $default,){
final _that = this;
switch (_that) {
case _SignInMethod() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SignInMethod implements SignInMethod {
  const _SignInMethod({@JsonKey(name: 'method') required this.method, @JsonKey(name: 'linked') this.linked = false, @JsonKey(name: 'maskedAccount') this.maskedAccount});
  factory _SignInMethod.fromJson(Map<String, dynamic> json) => _$SignInMethodFromJson(json);

@override@JsonKey(name: 'method') final  AuthMethod method;
@override@JsonKey(name: 'linked') final  bool linked;
@override@JsonKey(name: 'maskedAccount') final  String? maskedAccount;

/// Create a copy of SignInMethod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignInMethodCopyWith<_SignInMethod> get copyWith => __$SignInMethodCopyWithImpl<_SignInMethod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignInMethodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInMethod&&(identical(other.method, method) || other.method == method)&&(identical(other.linked, linked) || other.linked == linked)&&(identical(other.maskedAccount, maskedAccount) || other.maskedAccount == maskedAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,linked,maskedAccount);

@override
String toString() {
  return 'SignInMethod(method: $method, linked: $linked, maskedAccount: $maskedAccount)';
}


}

/// @nodoc
abstract mixin class _$SignInMethodCopyWith<$Res> implements $SignInMethodCopyWith<$Res> {
  factory _$SignInMethodCopyWith(_SignInMethod value, $Res Function(_SignInMethod) _then) = __$SignInMethodCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'method') AuthMethod method,@JsonKey(name: 'linked') bool linked,@JsonKey(name: 'maskedAccount') String? maskedAccount
});




}
/// @nodoc
class __$SignInMethodCopyWithImpl<$Res>
    implements _$SignInMethodCopyWith<$Res> {
  __$SignInMethodCopyWithImpl(this._self, this._then);

  final _SignInMethod _self;
  final $Res Function(_SignInMethod) _then;

/// Create a copy of SignInMethod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? linked = null,Object? maskedAccount = freezed,}) {
  return _then(_SignInMethod(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as AuthMethod,linked: null == linked ? _self.linked : linked // ignore: cast_nullable_to_non_nullable
as bool,maskedAccount: freezed == maskedAccount ? _self.maskedAccount : maskedAccount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
