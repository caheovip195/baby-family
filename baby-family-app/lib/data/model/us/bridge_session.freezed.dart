// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BridgeSession {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'status') BridgeStatus get status;@JsonKey(name: 'initiatorUserId') String get initiatorUserId;@JsonKey(name: 'startedAt') DateTime? get startedAt;@JsonKey(name: 'wizardStep') int get wizardStep;@JsonKey(name: 'privateNote') String? get privateNote;@JsonKey(name: 'shares') List<BridgeShare> get shares;@JsonKey(name: 'nextStep') BridgeNextStep? get nextStep;@JsonKey(name: 'closeAgreedUserIds') List<String> get closeAgreedUserIds;@JsonKey(name: 'retentionDays') int get retentionDays;
/// Create a copy of BridgeSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BridgeSessionCopyWith<BridgeSession> get copyWith => _$BridgeSessionCopyWithImpl<BridgeSession>(this as BridgeSession, _$identity);

  /// Serializes this BridgeSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BridgeSession&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.initiatorUserId, initiatorUserId) || other.initiatorUserId == initiatorUserId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.wizardStep, wizardStep) || other.wizardStep == wizardStep)&&(identical(other.privateNote, privateNote) || other.privateNote == privateNote)&&const DeepCollectionEquality().equals(other.shares, shares)&&(identical(other.nextStep, nextStep) || other.nextStep == nextStep)&&const DeepCollectionEquality().equals(other.closeAgreedUserIds, closeAgreedUserIds)&&(identical(other.retentionDays, retentionDays) || other.retentionDays == retentionDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,initiatorUserId,startedAt,wizardStep,privateNote,const DeepCollectionEquality().hash(shares),nextStep,const DeepCollectionEquality().hash(closeAgreedUserIds),retentionDays);

@override
String toString() {
  return 'BridgeSession(id: $id, status: $status, initiatorUserId: $initiatorUserId, startedAt: $startedAt, wizardStep: $wizardStep, privateNote: $privateNote, shares: $shares, nextStep: $nextStep, closeAgreedUserIds: $closeAgreedUserIds, retentionDays: $retentionDays)';
}


}

/// @nodoc
abstract mixin class $BridgeSessionCopyWith<$Res>  {
  factory $BridgeSessionCopyWith(BridgeSession value, $Res Function(BridgeSession) _then) = _$BridgeSessionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'status') BridgeStatus status,@JsonKey(name: 'initiatorUserId') String initiatorUserId,@JsonKey(name: 'startedAt') DateTime? startedAt,@JsonKey(name: 'wizardStep') int wizardStep,@JsonKey(name: 'privateNote') String? privateNote,@JsonKey(name: 'shares') List<BridgeShare> shares,@JsonKey(name: 'nextStep') BridgeNextStep? nextStep,@JsonKey(name: 'closeAgreedUserIds') List<String> closeAgreedUserIds,@JsonKey(name: 'retentionDays') int retentionDays
});


$BridgeNextStepCopyWith<$Res>? get nextStep;

}
/// @nodoc
class _$BridgeSessionCopyWithImpl<$Res>
    implements $BridgeSessionCopyWith<$Res> {
  _$BridgeSessionCopyWithImpl(this._self, this._then);

  final BridgeSession _self;
  final $Res Function(BridgeSession) _then;

/// Create a copy of BridgeSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? initiatorUserId = null,Object? startedAt = freezed,Object? wizardStep = null,Object? privateNote = freezed,Object? shares = null,Object? nextStep = freezed,Object? closeAgreedUserIds = null,Object? retentionDays = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BridgeStatus,initiatorUserId: null == initiatorUserId ? _self.initiatorUserId : initiatorUserId // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wizardStep: null == wizardStep ? _self.wizardStep : wizardStep // ignore: cast_nullable_to_non_nullable
as int,privateNote: freezed == privateNote ? _self.privateNote : privateNote // ignore: cast_nullable_to_non_nullable
as String?,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as List<BridgeShare>,nextStep: freezed == nextStep ? _self.nextStep : nextStep // ignore: cast_nullable_to_non_nullable
as BridgeNextStep?,closeAgreedUserIds: null == closeAgreedUserIds ? _self.closeAgreedUserIds : closeAgreedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,retentionDays: null == retentionDays ? _self.retentionDays : retentionDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of BridgeSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BridgeNextStepCopyWith<$Res>? get nextStep {
    if (_self.nextStep == null) {
    return null;
  }

  return $BridgeNextStepCopyWith<$Res>(_self.nextStep!, (value) {
    return _then(_self.copyWith(nextStep: value));
  });
}
}


/// Adds pattern-matching-related methods to [BridgeSession].
extension BridgeSessionPatterns on BridgeSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BridgeSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BridgeSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BridgeSession value)  $default,){
final _that = this;
switch (_that) {
case _BridgeSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BridgeSession value)?  $default,){
final _that = this;
switch (_that) {
case _BridgeSession() when $default != null:
return $default(_that);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BridgeSession implements BridgeSession {
  const _BridgeSession({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'status') this.status = BridgeStatus.draft, @JsonKey(name: 'initiatorUserId') required this.initiatorUserId, @JsonKey(name: 'startedAt') this.startedAt, @JsonKey(name: 'wizardStep') this.wizardStep = 1, @JsonKey(name: 'privateNote') this.privateNote, @JsonKey(name: 'shares') final  List<BridgeShare> shares = const [], @JsonKey(name: 'nextStep') this.nextStep, @JsonKey(name: 'closeAgreedUserIds') final  List<String> closeAgreedUserIds = const [], @JsonKey(name: 'retentionDays') this.retentionDays = 30}): _shares = shares,_closeAgreedUserIds = closeAgreedUserIds;
  factory _BridgeSession.fromJson(Map<String, dynamic> json) => _$BridgeSessionFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'status') final  BridgeStatus status;
@override@JsonKey(name: 'initiatorUserId') final  String initiatorUserId;
@override@JsonKey(name: 'startedAt') final  DateTime? startedAt;
@override@JsonKey(name: 'wizardStep') final  int wizardStep;
@override@JsonKey(name: 'privateNote') final  String? privateNote;
 final  List<BridgeShare> _shares;
@override@JsonKey(name: 'shares') List<BridgeShare> get shares {
  if (_shares is EqualUnmodifiableListView) return _shares;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shares);
}

@override@JsonKey(name: 'nextStep') final  BridgeNextStep? nextStep;
 final  List<String> _closeAgreedUserIds;
@override@JsonKey(name: 'closeAgreedUserIds') List<String> get closeAgreedUserIds {
  if (_closeAgreedUserIds is EqualUnmodifiableListView) return _closeAgreedUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_closeAgreedUserIds);
}

@override@JsonKey(name: 'retentionDays') final  int retentionDays;

/// Create a copy of BridgeSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BridgeSessionCopyWith<_BridgeSession> get copyWith => __$BridgeSessionCopyWithImpl<_BridgeSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BridgeSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BridgeSession&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.initiatorUserId, initiatorUserId) || other.initiatorUserId == initiatorUserId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.wizardStep, wizardStep) || other.wizardStep == wizardStep)&&(identical(other.privateNote, privateNote) || other.privateNote == privateNote)&&const DeepCollectionEquality().equals(other._shares, _shares)&&(identical(other.nextStep, nextStep) || other.nextStep == nextStep)&&const DeepCollectionEquality().equals(other._closeAgreedUserIds, _closeAgreedUserIds)&&(identical(other.retentionDays, retentionDays) || other.retentionDays == retentionDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,initiatorUserId,startedAt,wizardStep,privateNote,const DeepCollectionEquality().hash(_shares),nextStep,const DeepCollectionEquality().hash(_closeAgreedUserIds),retentionDays);

@override
String toString() {
  return 'BridgeSession(id: $id, status: $status, initiatorUserId: $initiatorUserId, startedAt: $startedAt, wizardStep: $wizardStep, privateNote: $privateNote, shares: $shares, nextStep: $nextStep, closeAgreedUserIds: $closeAgreedUserIds, retentionDays: $retentionDays)';
}


}

/// @nodoc
abstract mixin class _$BridgeSessionCopyWith<$Res> implements $BridgeSessionCopyWith<$Res> {
  factory _$BridgeSessionCopyWith(_BridgeSession value, $Res Function(_BridgeSession) _then) = __$BridgeSessionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'status') BridgeStatus status,@JsonKey(name: 'initiatorUserId') String initiatorUserId,@JsonKey(name: 'startedAt') DateTime? startedAt,@JsonKey(name: 'wizardStep') int wizardStep,@JsonKey(name: 'privateNote') String? privateNote,@JsonKey(name: 'shares') List<BridgeShare> shares,@JsonKey(name: 'nextStep') BridgeNextStep? nextStep,@JsonKey(name: 'closeAgreedUserIds') List<String> closeAgreedUserIds,@JsonKey(name: 'retentionDays') int retentionDays
});


@override $BridgeNextStepCopyWith<$Res>? get nextStep;

}
/// @nodoc
class __$BridgeSessionCopyWithImpl<$Res>
    implements _$BridgeSessionCopyWith<$Res> {
  __$BridgeSessionCopyWithImpl(this._self, this._then);

  final _BridgeSession _self;
  final $Res Function(_BridgeSession) _then;

/// Create a copy of BridgeSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? initiatorUserId = null,Object? startedAt = freezed,Object? wizardStep = null,Object? privateNote = freezed,Object? shares = null,Object? nextStep = freezed,Object? closeAgreedUserIds = null,Object? retentionDays = null,}) {
  return _then(_BridgeSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BridgeStatus,initiatorUserId: null == initiatorUserId ? _self.initiatorUserId : initiatorUserId // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wizardStep: null == wizardStep ? _self.wizardStep : wizardStep // ignore: cast_nullable_to_non_nullable
as int,privateNote: freezed == privateNote ? _self.privateNote : privateNote // ignore: cast_nullable_to_non_nullable
as String?,shares: null == shares ? _self._shares : shares // ignore: cast_nullable_to_non_nullable
as List<BridgeShare>,nextStep: freezed == nextStep ? _self.nextStep : nextStep // ignore: cast_nullable_to_non_nullable
as BridgeNextStep?,closeAgreedUserIds: null == closeAgreedUserIds ? _self._closeAgreedUserIds : closeAgreedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,retentionDays: null == retentionDays ? _self.retentionDays : retentionDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of BridgeSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BridgeNextStepCopyWith<$Res>? get nextStep {
    if (_self.nextStep == null) {
    return null;
  }

  return $BridgeNextStepCopyWith<$Res>(_self.nextStep!, (value) {
    return _then(_self.copyWith(nextStep: value));
  });
}
}

// dart format on
