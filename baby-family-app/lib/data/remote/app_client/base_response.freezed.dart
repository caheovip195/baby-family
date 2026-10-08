// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
BaseRespond _$BaseRespondFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'authCertificateRespond':
          return AuthCertificateRespond.fromJson(
            json
          );
                case 'userRespond':
          return UserRespond.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'BaseRespond',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$BaseRespond {



  /// Serializes this BaseRespond to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseRespond);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BaseRespond()';
}


}

/// @nodoc
class $BaseRespondCopyWith<$Res>  {
$BaseRespondCopyWith(BaseRespond _, $Res Function(BaseRespond) __);
}


/// Adds pattern-matching-related methods to [BaseRespond].
extension BaseRespondPatterns on BaseRespond {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthCertificateRespond value)?  authCertificateRespond,TResult Function( UserRespond value)?  userRespond,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthCertificateRespond() when authCertificateRespond != null:
return authCertificateRespond(_that);case UserRespond() when userRespond != null:
return userRespond(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthCertificateRespond value)  authCertificateRespond,required TResult Function( UserRespond value)  userRespond,}){
final _that = this;
switch (_that) {
case AuthCertificateRespond():
return authCertificateRespond(_that);case UserRespond():
return userRespond(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthCertificateRespond value)?  authCertificateRespond,TResult? Function( UserRespond value)?  userRespond,}){
final _that = this;
switch (_that) {
case AuthCertificateRespond() when authCertificateRespond != null:
return authCertificateRespond(_that);case UserRespond() when userRespond != null:
return userRespond(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@JsonKey(name: 'data')  AuthCertificate? auth)?  authCertificateRespond,TResult Function(@JsonKey(name: 'data')  User? user)?  userRespond,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthCertificateRespond() when authCertificateRespond != null:
return authCertificateRespond(_that.auth);case UserRespond() when userRespond != null:
return userRespond(_that.user);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@JsonKey(name: 'data')  AuthCertificate? auth)  authCertificateRespond,required TResult Function(@JsonKey(name: 'data')  User? user)  userRespond,}) {final _that = this;
switch (_that) {
case AuthCertificateRespond():
return authCertificateRespond(_that.auth);case UserRespond():
return userRespond(_that.user);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@JsonKey(name: 'data')  AuthCertificate? auth)?  authCertificateRespond,TResult? Function(@JsonKey(name: 'data')  User? user)?  userRespond,}) {final _that = this;
switch (_that) {
case AuthCertificateRespond() when authCertificateRespond != null:
return authCertificateRespond(_that.auth);case UserRespond() when userRespond != null:
return userRespond(_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class AuthCertificateRespond extends BaseRespond {
   AuthCertificateRespond({@JsonKey(name: 'data') this.auth, final  String? $type}): $type = $type ?? 'authCertificateRespond',super._();
  factory AuthCertificateRespond.fromJson(Map<String, dynamic> json) => _$AuthCertificateRespondFromJson(json);

@JsonKey(name: 'data') final  AuthCertificate? auth;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of BaseRespond
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthCertificateRespondCopyWith<AuthCertificateRespond> get copyWith => _$AuthCertificateRespondCopyWithImpl<AuthCertificateRespond>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthCertificateRespondToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthCertificateRespond&&(identical(other.auth, auth) || other.auth == auth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,auth);

@override
String toString() {
  return 'BaseRespond.authCertificateRespond(auth: $auth)';
}


}

/// @nodoc
abstract mixin class $AuthCertificateRespondCopyWith<$Res> implements $BaseRespondCopyWith<$Res> {
  factory $AuthCertificateRespondCopyWith(AuthCertificateRespond value, $Res Function(AuthCertificateRespond) _then) = _$AuthCertificateRespondCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'data') AuthCertificate? auth
});


$AuthCertificateCopyWith<$Res>? get auth;

}
/// @nodoc
class _$AuthCertificateRespondCopyWithImpl<$Res>
    implements $AuthCertificateRespondCopyWith<$Res> {
  _$AuthCertificateRespondCopyWithImpl(this._self, this._then);

  final AuthCertificateRespond _self;
  final $Res Function(AuthCertificateRespond) _then;

/// Create a copy of BaseRespond
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? auth = freezed,}) {
  return _then(AuthCertificateRespond(
auth: freezed == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as AuthCertificate?,
  ));
}

/// Create a copy of BaseRespond
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthCertificateCopyWith<$Res>? get auth {
    if (_self.auth == null) {
    return null;
  }

  return $AuthCertificateCopyWith<$Res>(_self.auth!, (value) {
    return _then(_self.copyWith(auth: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class UserRespond extends BaseRespond {
   UserRespond({@JsonKey(name: 'data') this.user, final  String? $type}): $type = $type ?? 'userRespond',super._();
  factory UserRespond.fromJson(Map<String, dynamic> json) => _$UserRespondFromJson(json);

@JsonKey(name: 'data') final  User? user;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of BaseRespond
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRespondCopyWith<UserRespond> get copyWith => _$UserRespondCopyWithImpl<UserRespond>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRespondToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRespond&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'BaseRespond.userRespond(user: $user)';
}


}

/// @nodoc
abstract mixin class $UserRespondCopyWith<$Res> implements $BaseRespondCopyWith<$Res> {
  factory $UserRespondCopyWith(UserRespond value, $Res Function(UserRespond) _then) = _$UserRespondCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'data') User? user
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$UserRespondCopyWithImpl<$Res>
    implements $UserRespondCopyWith<$Res> {
  _$UserRespondCopyWithImpl(this._self, this._then);

  final UserRespond _self;
  final $Res Function(UserRespond) _then;

/// Create a copy of BaseRespond
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = freezed,}) {
  return _then(UserRespond(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,
  ));
}

/// Create a copy of BaseRespond
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
