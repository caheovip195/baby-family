// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partner_invite_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartnerInviteStatus {

@JsonKey(name: 'inviteId') String? get inviteId;@JsonKey(name: 'status') String? get status;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'requireFinalApproval') bool get requireFinalApproval;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;@JsonKey(name: 'acceptedCallName') String? get acceptedCallName;
/// Create a copy of PartnerInviteStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnerInviteStatusCopyWith<PartnerInviteStatus> get copyWith => _$PartnerInviteStatusCopyWithImpl<PartnerInviteStatus>(this as PartnerInviteStatus, _$identity);

  /// Serializes this PartnerInviteStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnerInviteStatus&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.status, status) || other.status == status)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.requireFinalApproval, requireFinalApproval) || other.requireFinalApproval == requireFinalApproval)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.acceptedCallName, acceptedCallName) || other.acceptedCallName == acceptedCallName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,status,kind,requireFinalApproval,createdAt,expiresAt,acceptedCallName);

@override
String toString() {
  return 'PartnerInviteStatus(inviteId: $inviteId, status: $status, kind: $kind, requireFinalApproval: $requireFinalApproval, createdAt: $createdAt, expiresAt: $expiresAt, acceptedCallName: $acceptedCallName)';
}


}

/// @nodoc
abstract mixin class $PartnerInviteStatusCopyWith<$Res>  {
  factory $PartnerInviteStatusCopyWith(PartnerInviteStatus value, $Res Function(PartnerInviteStatus) _then) = _$PartnerInviteStatusCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'status') String? status,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'requireFinalApproval') bool requireFinalApproval,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'acceptedCallName') String? acceptedCallName
});




}
/// @nodoc
class _$PartnerInviteStatusCopyWithImpl<$Res>
    implements $PartnerInviteStatusCopyWith<$Res> {
  _$PartnerInviteStatusCopyWithImpl(this._self, this._then);

  final PartnerInviteStatus _self;
  final $Res Function(PartnerInviteStatus) _then;

/// Create a copy of PartnerInviteStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inviteId = freezed,Object? status = freezed,Object? kind = freezed,Object? requireFinalApproval = null,Object? createdAt = freezed,Object? expiresAt = freezed,Object? acceptedCallName = freezed,}) {
  return _then(_self.copyWith(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,requireFinalApproval: null == requireFinalApproval ? _self.requireFinalApproval : requireFinalApproval // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedCallName: freezed == acceptedCallName ? _self.acceptedCallName : acceptedCallName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PartnerInviteStatus].
extension PartnerInviteStatusPatterns on PartnerInviteStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnerInviteStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnerInviteStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnerInviteStatus value)  $default,){
final _that = this;
switch (_that) {
case _PartnerInviteStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnerInviteStatus value)?  $default,){
final _that = this;
switch (_that) {
case _PartnerInviteStatus() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PartnerInviteStatus implements PartnerInviteStatus {
  const _PartnerInviteStatus({@JsonKey(name: 'inviteId') this.inviteId, @JsonKey(name: 'status') this.status, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'requireFinalApproval') this.requireFinalApproval = true, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'expiresAt') this.expiresAt, @JsonKey(name: 'acceptedCallName') this.acceptedCallName});
  factory _PartnerInviteStatus.fromJson(Map<String, dynamic> json) => _$PartnerInviteStatusFromJson(json);

@override@JsonKey(name: 'inviteId') final  String? inviteId;
@override@JsonKey(name: 'status') final  String? status;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'requireFinalApproval') final  bool requireFinalApproval;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;
@override@JsonKey(name: 'acceptedCallName') final  String? acceptedCallName;

/// Create a copy of PartnerInviteStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnerInviteStatusCopyWith<_PartnerInviteStatus> get copyWith => __$PartnerInviteStatusCopyWithImpl<_PartnerInviteStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartnerInviteStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnerInviteStatus&&(identical(other.inviteId, inviteId) || other.inviteId == inviteId)&&(identical(other.status, status) || other.status == status)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.requireFinalApproval, requireFinalApproval) || other.requireFinalApproval == requireFinalApproval)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.acceptedCallName, acceptedCallName) || other.acceptedCallName == acceptedCallName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteId,status,kind,requireFinalApproval,createdAt,expiresAt,acceptedCallName);

@override
String toString() {
  return 'PartnerInviteStatus(inviteId: $inviteId, status: $status, kind: $kind, requireFinalApproval: $requireFinalApproval, createdAt: $createdAt, expiresAt: $expiresAt, acceptedCallName: $acceptedCallName)';
}


}

/// @nodoc
abstract mixin class _$PartnerInviteStatusCopyWith<$Res> implements $PartnerInviteStatusCopyWith<$Res> {
  factory _$PartnerInviteStatusCopyWith(_PartnerInviteStatus value, $Res Function(_PartnerInviteStatus) _then) = __$PartnerInviteStatusCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'inviteId') String? inviteId,@JsonKey(name: 'status') String? status,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'requireFinalApproval') bool requireFinalApproval,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'acceptedCallName') String? acceptedCallName
});




}
/// @nodoc
class __$PartnerInviteStatusCopyWithImpl<$Res>
    implements _$PartnerInviteStatusCopyWith<$Res> {
  __$PartnerInviteStatusCopyWithImpl(this._self, this._then);

  final _PartnerInviteStatus _self;
  final $Res Function(_PartnerInviteStatus) _then;

/// Create a copy of PartnerInviteStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inviteId = freezed,Object? status = freezed,Object? kind = freezed,Object? requireFinalApproval = null,Object? createdAt = freezed,Object? expiresAt = freezed,Object? acceptedCallName = freezed,}) {
  return _then(_PartnerInviteStatus(
inviteId: freezed == inviteId ? _self.inviteId : inviteId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,requireFinalApproval: null == requireFinalApproval ? _self.requireFinalApproval : requireFinalApproval // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedCallName: freezed == acceptedCallName ? _self.acceptedCallName : acceptedCallName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
