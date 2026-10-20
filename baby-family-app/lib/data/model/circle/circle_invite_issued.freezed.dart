// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_invite_issued.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircleInviteIssued {

@JsonKey(name: 'inviteId') String? get inviteId;@JsonKey(name: 'code') String? get code;@JsonKey(name: 'url') String? get url;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;
/// Create a copy of CircleInviteIssued
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleInviteIssuedCopyWith<CircleInviteIssued> get copyWith => _$CircleInviteIssuedCopyWithImpl<CircleInviteIssued>(this as CircleInviteIssued, _$identity);

  /// Serializes this CircleInviteIssued to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleInviteIssued&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.code, code) || other.code == code)&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,code,url,expiresAt);

@override
String toString() {
  return 'CircleInviteIssued(inviteId: $inviteId, code: $code, url: $url, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $CircleInviteIssuedCopyWith<$Res>  {
  factory $CircleInviteIssuedCopyWith(CircleInviteIssued value, $Res Function(CircleInviteIssued) _then) = _$CircleInviteIssuedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'code') String? code,@JsonKey(name: 'url') String? url,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class _$CircleInviteIssuedCopyWithImpl<$Res>
    implements $CircleInviteIssuedCopyWith<$Res> {
  _$CircleInviteIssuedCopyWithImpl(this._self, this._then);

  final CircleInviteIssued _self;
  final $Res Function(CircleInviteIssued) _then;

/// Create a copy of CircleInviteIssued
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inviteId = freezed,Object? code = freezed,Object? url = freezed,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleInviteIssued].
extension CircleInviteIssuedPatterns on CircleInviteIssued {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleInviteIssued value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleInviteIssued() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleInviteIssued value)  $default,){
final _that = this;
switch (_that) {
case _CircleInviteIssued():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleInviteIssued value)?  $default,){
final _that = this;
switch (_that) {
case _CircleInviteIssued() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CircleInviteIssued implements CircleInviteIssued {
  const _CircleInviteIssued({@JsonKey(name: 'inviteId') this.inviteId, @JsonKey(name: 'code') this.code, @JsonKey(name: 'url') this.url, @JsonKey(name: 'expiresAt') this.expiresAt});
  factory _CircleInviteIssued.fromJson(Map<String, dynamic> json) => _$CircleInviteIssuedFromJson(json);

@override@JsonKey(name: 'inviteId') final  String? inviteId;
@override@JsonKey(name: 'code') final  String? code;
@override@JsonKey(name: 'url') final  String? url;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;

/// Create a copy of CircleInviteIssued
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleInviteIssuedCopyWith<_CircleInviteIssued> get copyWith => __$CircleInviteIssuedCopyWithImpl<_CircleInviteIssued>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleInviteIssuedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleInviteIssued&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.code, code) || other.code == code)&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,code,url,expiresAt);

@override
String toString() {
  return 'CircleInviteIssued(inviteId: $inviteId, code: $code, url: $url, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$CircleInviteIssuedCopyWith<$Res> implements $CircleInviteIssuedCopyWith<$Res> {
  factory _$CircleInviteIssuedCopyWith(_CircleInviteIssued value, $Res Function(_CircleInviteIssued) _then) = __$CircleInviteIssuedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'code') String? code,@JsonKey(name: 'url') String? url,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class __$CircleInviteIssuedCopyWithImpl<$Res>
    implements _$CircleInviteIssuedCopyWith<$Res> {
  __$CircleInviteIssuedCopyWithImpl(this._self, this._then);

  final _CircleInviteIssued _self;
  final $Res Function(_CircleInviteIssued) _then;

/// Create a copy of CircleInviteIssued
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inviteId = freezed,Object? code = freezed,Object? url = freezed,Object? expiresAt = freezed,}) {
  return _then(_CircleInviteIssued(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
