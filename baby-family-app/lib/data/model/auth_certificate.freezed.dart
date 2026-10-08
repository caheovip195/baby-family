// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_certificate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthCertificate {

@JsonKey(name: 'accessToken') String? get accessToken;@JsonKey(name: 'refreshToken') String? get refreshToken;/// Thời hạn access token (giây).
@JsonKey(name: 'expiresIn') int? get expiresIn;@JsonKey(name: 'user') User? get user;@JsonKey(name: 'expiredAccessTokenDateTime') DateTime? get expiredAccessTokenDateTime;
/// Create a copy of AuthCertificate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthCertificateCopyWith<AuthCertificate> get copyWith => _$AuthCertificateCopyWithImpl<AuthCertificate>(this as AuthCertificate, _$identity);

  /// Serializes this AuthCertificate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthCertificate&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.user, user) || other.user == user)&&(identical(other.expiredAccessTokenDateTime, expiredAccessTokenDateTime) || other.expiredAccessTokenDateTime == expiredAccessTokenDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresIn,user,expiredAccessTokenDateTime);

@override
String toString() {
  return 'AuthCertificate(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, user: $user, expiredAccessTokenDateTime: $expiredAccessTokenDateTime)';
}


}

/// @nodoc
abstract mixin class $AuthCertificateCopyWith<$Res>  {
  factory $AuthCertificateCopyWith(AuthCertificate value, $Res Function(AuthCertificate) _then) = _$AuthCertificateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'accessToken') String? accessToken,@JsonKey(name: 'refreshToken') String? refreshToken,@JsonKey(name: 'expiresIn') int? expiresIn,@JsonKey(name: 'user') User? user,@JsonKey(name: 'expiredAccessTokenDateTime') DateTime? expiredAccessTokenDateTime
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$AuthCertificateCopyWithImpl<$Res>
    implements $AuthCertificateCopyWith<$Res> {
  _$AuthCertificateCopyWithImpl(this._self, this._then);

  final AuthCertificate _self;
  final $Res Function(AuthCertificate) _then;

/// Create a copy of AuthCertificate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = freezed,Object? refreshToken = freezed,Object? expiresIn = freezed,Object? user = freezed,Object? expiredAccessTokenDateTime = freezed,}) {
  return _then(_self.copyWith(
accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,expiresIn: freezed == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,expiredAccessTokenDateTime: freezed == expiredAccessTokenDateTime ? _self.expiredAccessTokenDateTime : expiredAccessTokenDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of AuthCertificate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthCertificate].
extension AuthCertificatePatterns on AuthCertificate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthCertificate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthCertificate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthCertificate value)  $default,){
final _that = this;
switch (_that) {
case _AuthCertificate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthCertificate value)?  $default,){
final _that = this;
switch (_that) {
case _AuthCertificate() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AuthCertificate implements AuthCertificate {
  const _AuthCertificate({@JsonKey(name: 'accessToken') this.accessToken, @JsonKey(name: 'refreshToken') this.refreshToken, @JsonKey(name: 'expiresIn') this.expiresIn, @JsonKey(name: 'user') this.user, @JsonKey(name: 'expiredAccessTokenDateTime') this.expiredAccessTokenDateTime});
  factory _AuthCertificate.fromJson(Map<String, dynamic> json) => _$AuthCertificateFromJson(json);

@override@JsonKey(name: 'accessToken') final  String? accessToken;
@override@JsonKey(name: 'refreshToken') final  String? refreshToken;
/// Thời hạn access token (giây).
@override@JsonKey(name: 'expiresIn') final  int? expiresIn;
@override@JsonKey(name: 'user') final  User? user;
@override@JsonKey(name: 'expiredAccessTokenDateTime') final  DateTime? expiredAccessTokenDateTime;

/// Create a copy of AuthCertificate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthCertificateCopyWith<_AuthCertificate> get copyWith => __$AuthCertificateCopyWithImpl<_AuthCertificate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthCertificateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthCertificate&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.user, user) || other.user == user)&&(identical(other.expiredAccessTokenDateTime, expiredAccessTokenDateTime) || other.expiredAccessTokenDateTime == expiredAccessTokenDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresIn,user,expiredAccessTokenDateTime);

@override
String toString() {
  return 'AuthCertificate(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, user: $user, expiredAccessTokenDateTime: $expiredAccessTokenDateTime)';
}


}

/// @nodoc
abstract mixin class _$AuthCertificateCopyWith<$Res> implements $AuthCertificateCopyWith<$Res> {
  factory _$AuthCertificateCopyWith(_AuthCertificate value, $Res Function(_AuthCertificate) _then) = __$AuthCertificateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'accessToken') String? accessToken,@JsonKey(name: 'refreshToken') String? refreshToken,@JsonKey(name: 'expiresIn') int? expiresIn,@JsonKey(name: 'user') User? user,@JsonKey(name: 'expiredAccessTokenDateTime') DateTime? expiredAccessTokenDateTime
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$AuthCertificateCopyWithImpl<$Res>
    implements _$AuthCertificateCopyWith<$Res> {
  __$AuthCertificateCopyWithImpl(this._self, this._then);

  final _AuthCertificate _self;
  final $Res Function(_AuthCertificate) _then;

/// Create a copy of AuthCertificate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = freezed,Object? refreshToken = freezed,Object? expiresIn = freezed,Object? user = freezed,Object? expiredAccessTokenDateTime = freezed,}) {
  return _then(_AuthCertificate(
accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,expiresIn: freezed == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,expiredAccessTokenDateTime: freezed == expiredAccessTokenDateTime ? _self.expiredAccessTokenDateTime : expiredAccessTokenDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of AuthCertificate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
