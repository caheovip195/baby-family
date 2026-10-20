// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partner_invite_issued.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartnerInviteIssued {

@JsonKey(name: 'inviteId') String? get inviteId;@JsonKey(name: 'url') String? get url;@JsonKey(name: 'code') String? get code;@JsonKey(name: 'qrPayload') String? get qrPayload;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;
/// Create a copy of PartnerInviteIssued
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnerInviteIssuedCopyWith<PartnerInviteIssued> get copyWith => _$PartnerInviteIssuedCopyWithImpl<PartnerInviteIssued>(this as PartnerInviteIssued, _$identity);

  /// Serializes this PartnerInviteIssued to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnerInviteIssued&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.url, url) || other.url == url)&&(identical(other.code, code) || other.code == code)&&(identical(other.qrPayload, qrPayload) || other.qrPayload == qrPayload)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,url,code,qrPayload,expiresAt);

@override
String toString() {
  return 'PartnerInviteIssued(inviteId: $inviteId, url: $url, code: $code, qrPayload: $qrPayload, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $PartnerInviteIssuedCopyWith<$Res>  {
  factory $PartnerInviteIssuedCopyWith(PartnerInviteIssued value, $Res Function(PartnerInviteIssued) _then) = _$PartnerInviteIssuedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'url') String? url,@JsonKey(name: 'code') String? code,@JsonKey(name: 'qrPayload') String? qrPayload,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class _$PartnerInviteIssuedCopyWithImpl<$Res>
    implements $PartnerInviteIssuedCopyWith<$Res> {
  _$PartnerInviteIssuedCopyWithImpl(this._self, this._then);

  final PartnerInviteIssued _self;
  final $Res Function(PartnerInviteIssued) _then;

/// Create a copy of PartnerInviteIssued
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inviteId = freezed,Object? url = freezed,Object? code = freezed,Object? qrPayload = freezed,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,qrPayload: freezed == qrPayload ? _self.qrPayload : qrPayload // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PartnerInviteIssued].
extension PartnerInviteIssuedPatterns on PartnerInviteIssued {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnerInviteIssued value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnerInviteIssued() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnerInviteIssued value)  $default,){
final _that = this;
switch (_that) {
case _PartnerInviteIssued():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnerInviteIssued value)?  $default,){
final _that = this;
switch (_that) {
case _PartnerInviteIssued() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PartnerInviteIssued implements PartnerInviteIssued {
  const _PartnerInviteIssued({@JsonKey(name: 'inviteId') this.inviteId, @JsonKey(name: 'url') this.url, @JsonKey(name: 'code') this.code, @JsonKey(name: 'qrPayload') this.qrPayload, @JsonKey(name: 'expiresAt') this.expiresAt});
  factory _PartnerInviteIssued.fromJson(Map<String, dynamic> json) => _$PartnerInviteIssuedFromJson(json);

@override@JsonKey(name: 'inviteId') final  String? inviteId;
@override@JsonKey(name: 'url') final  String? url;
@override@JsonKey(name: 'code') final  String? code;
@override@JsonKey(name: 'qrPayload') final  String? qrPayload;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;

/// Create a copy of PartnerInviteIssued
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnerInviteIssuedCopyWith<_PartnerInviteIssued> get copyWith => __$PartnerInviteIssuedCopyWithImpl<_PartnerInviteIssued>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartnerInviteIssuedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnerInviteIssued&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.url, url) || other.url == url)&&(identical(other.code, code) || other.code == code)&&(identical(other.qrPayload, qrPayload) || other.qrPayload == qrPayload)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,url,code,qrPayload,expiresAt);

@override
String toString() {
  return 'PartnerInviteIssued(inviteId: $inviteId, url: $url, code: $code, qrPayload: $qrPayload, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$PartnerInviteIssuedCopyWith<$Res> implements $PartnerInviteIssuedCopyWith<$Res> {
  factory _$PartnerInviteIssuedCopyWith(_PartnerInviteIssued value, $Res Function(_PartnerInviteIssued) _then) = __$PartnerInviteIssuedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'url') String? url,@JsonKey(name: 'code') String? code,@JsonKey(name: 'qrPayload') String? qrPayload,@JsonKey(name: 'expiresAt') DateTime? expiresAt
});




}
/// @nodoc
class __$PartnerInviteIssuedCopyWithImpl<$Res>
    implements _$PartnerInviteIssuedCopyWith<$Res> {
  __$PartnerInviteIssuedCopyWithImpl(this._self, this._then);

  final _PartnerInviteIssued _self;
  final $Res Function(_PartnerInviteIssued) _then;

/// Create a copy of PartnerInviteIssued
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inviteId = freezed,Object? url = freezed,Object? code = freezed,Object? qrPayload = freezed,Object? expiresAt = freezed,}) {
  return _then(_PartnerInviteIssued(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,qrPayload: freezed == qrPayload ? _self.qrPayload : qrPayload // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
