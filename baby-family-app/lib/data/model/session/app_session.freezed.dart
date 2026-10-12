// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSession {

@JsonKey(name: 'state') SessionState get state;@JsonKey(name: 'userId') String? get userId;@JsonKey(name: 'familyId') String? get familyId;@JsonKey(name: 'memberId') String? get memberId;@JsonKey(name: 'role') FamilyRole? get role;@JsonKey(name: 'callName') String? get callName;@JsonKey(name: 'authMethod') AuthMethod? get authMethod;@JsonKey(name: 'phone') String? get phone;@JsonKey(name: 'stage') FamilyStage? get stage;@JsonKey(name: 'pendingInvite') PendingInvite? get pendingInvite;
/// Create a copy of AppSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSessionCopyWith<AppSession> get copyWith => _$AppSessionCopyWithImpl<AppSession>(this as AppSession, _$identity);

  /// Serializes this AppSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSession&&(identical(other.state, state) || other.state == state)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.role, role) || other.role == role)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.authMethod, authMethod) || other.authMethod == authMethod)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.pendingInvite, pendingInvite) || other.pendingInvite == pendingInvite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,userId,familyId,memberId,role,callName,authMethod,phone,stage,pendingInvite);

@override
String toString() {
  return 'AppSession(state: $state, userId: $userId, familyId: $familyId, memberId: $memberId, role: $role, callName: $callName, authMethod: $authMethod, phone: $phone, stage: $stage, pendingInvite: $pendingInvite)';
}


}

/// @nodoc
abstract mixin class $AppSessionCopyWith<$Res>  {
  factory $AppSessionCopyWith(AppSession value, $Res Function(AppSession) _then) = _$AppSessionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'state') SessionState state,@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'memberId') String? memberId,@JsonKey(name: 'role') FamilyRole? role,@JsonKey(name: 'callName') String? callName,@JsonKey(name: 'authMethod') AuthMethod? authMethod,@JsonKey(name: 'phone') String? phone,@JsonKey(name: 'stage') FamilyStage? stage,@JsonKey(name: 'pendingInvite') PendingInvite? pendingInvite
});


$PendingInviteCopyWith<$Res>? get pendingInvite;

}
/// @nodoc
class _$AppSessionCopyWithImpl<$Res>
    implements $AppSessionCopyWith<$Res> {
  _$AppSessionCopyWithImpl(this._self, this._then);

  final AppSession _self;
  final $Res Function(AppSession) _then;

/// Create a copy of AppSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? userId = freezed,Object? familyId = freezed,Object? memberId = freezed,Object? role = freezed,Object? callName = freezed,Object? authMethod = freezed,Object? phone = freezed,Object? stage = freezed,Object? pendingInvite = freezed,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as SessionState,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole?,callName: freezed == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String?,authMethod: freezed == authMethod ? _self.authMethod : authMethod // ignore: cast_nullable_to_non_nullable
as AuthMethod?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as FamilyStage?,pendingInvite: freezed == pendingInvite ? _self.pendingInvite : pendingInvite // ignore: cast_nullable_to_non_nullable
as PendingInvite?,
  ));
}
/// Create a copy of AppSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PendingInviteCopyWith<$Res>? get pendingInvite {
    if (_self.pendingInvite == null) {
    return null;
  }

  return $PendingInviteCopyWith<$Res>(_self.pendingInvite!, (value) {
    return _then(_self.copyWith(pendingInvite: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppSession].
extension AppSessionPatterns on AppSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSession value)  $default,){
final _that = this;
switch (_that) {
case _AppSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSession value)?  $default,){
final _that = this;
switch (_that) {
case _AppSession() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AppSession implements AppSession {
  const _AppSession({@JsonKey(name: 'state') this.state = SessionState.signedOut, @JsonKey(name: 'userId') this.userId, @JsonKey(name: 'familyId') this.familyId, @JsonKey(name: 'memberId') this.memberId, @JsonKey(name: 'role') this.role, @JsonKey(name: 'callName') this.callName, @JsonKey(name: 'authMethod') this.authMethod, @JsonKey(name: 'phone') this.phone, @JsonKey(name: 'stage') this.stage, @JsonKey(name: 'pendingInvite') this.pendingInvite});
  factory _AppSession.fromJson(Map<String, dynamic> json) => _$AppSessionFromJson(json);

@override@JsonKey(name: 'state') final  SessionState state;
@override@JsonKey(name: 'userId') final  String? userId;
@override@JsonKey(name: 'familyId') final  String? familyId;
@override@JsonKey(name: 'memberId') final  String? memberId;
@override@JsonKey(name: 'role') final  FamilyRole? role;
@override@JsonKey(name: 'callName') final  String? callName;
@override@JsonKey(name: 'authMethod') final  AuthMethod? authMethod;
@override@JsonKey(name: 'phone') final  String? phone;
@override@JsonKey(name: 'stage') final  FamilyStage? stage;
@override@JsonKey(name: 'pendingInvite') final  PendingInvite? pendingInvite;

/// Create a copy of AppSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSessionCopyWith<_AppSession> get copyWith => __$AppSessionCopyWithImpl<_AppSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSession&&(identical(other.state, state) || other.state == state)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.role, role) || other.role == role)&&(identical(other.callName, callName) || other.callName == callName)&&(identical(other.authMethod, authMethod) || other.authMethod == authMethod)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.pendingInvite, pendingInvite) || other.pendingInvite == pendingInvite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,userId,familyId,memberId,role,callName,authMethod,phone,stage,pendingInvite);

@override
String toString() {
  return 'AppSession(state: $state, userId: $userId, familyId: $familyId, memberId: $memberId, role: $role, callName: $callName, authMethod: $authMethod, phone: $phone, stage: $stage, pendingInvite: $pendingInvite)';
}


}

/// @nodoc
abstract mixin class _$AppSessionCopyWith<$Res> implements $AppSessionCopyWith<$Res> {
  factory _$AppSessionCopyWith(_AppSession value, $Res Function(_AppSession) _then) = __$AppSessionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'state') SessionState state,@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'familyId') String? familyId,@JsonKey(name: 'memberId') String? memberId,@JsonKey(name: 'role') FamilyRole? role,@JsonKey(name: 'callName') String? callName,@JsonKey(name: 'authMethod') AuthMethod? authMethod,@JsonKey(name: 'phone') String? phone,@JsonKey(name: 'stage') FamilyStage? stage,@JsonKey(name: 'pendingInvite') PendingInvite? pendingInvite
});


@override $PendingInviteCopyWith<$Res>? get pendingInvite;

}
/// @nodoc
class __$AppSessionCopyWithImpl<$Res>
    implements _$AppSessionCopyWith<$Res> {
  __$AppSessionCopyWithImpl(this._self, this._then);

  final _AppSession _self;
  final $Res Function(_AppSession) _then;

/// Create a copy of AppSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? userId = freezed,Object? familyId = freezed,Object? memberId = freezed,Object? role = freezed,Object? callName = freezed,Object? authMethod = freezed,Object? phone = freezed,Object? stage = freezed,Object? pendingInvite = freezed,}) {
  return _then(_AppSession(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as SessionState,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole?,callName: freezed == callName ? _self.callName : callName // ignore: cast_nullable_to_non_nullable
as String?,authMethod: freezed == authMethod ? _self.authMethod : authMethod // ignore: cast_nullable_to_non_nullable
as AuthMethod?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as FamilyStage?,pendingInvite: freezed == pendingInvite ? _self.pendingInvite : pendingInvite // ignore: cast_nullable_to_non_nullable
as PendingInvite?,
  ));
}

/// Create a copy of AppSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PendingInviteCopyWith<$Res>? get pendingInvite {
    if (_self.pendingInvite == null) {
    return null;
  }

  return $PendingInviteCopyWith<$Res>(_self.pendingInvite!, (value) {
    return _then(_self.copyWith(pendingInvite: value));
  });
}
}

// dart format on
