// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSession _$AppSessionFromJson(Map<String, dynamic> json) => _AppSession(
  state:
      $enumDecodeNullable(_$SessionStateEnumMap, json['state']) ??
      SessionState.signedOut,
  userId: json['userId'] as String?,
  familyId: json['familyId'] as String?,
  memberId: json['memberId'] as String?,
  role: $enumDecodeNullable(_$FamilyRoleEnumMap, json['role']),
  callName: json['callName'] as String?,
  authMethod: $enumDecodeNullable(_$AuthMethodEnumMap, json['authMethod']),
  phone: json['phone'] as String?,
  stage: $enumDecodeNullable(_$FamilyStageEnumMap, json['stage']),
  pendingInvite: json['pendingInvite'] == null
      ? null
      : PendingInvite.fromJson(json['pendingInvite'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppSessionToJson(_AppSession instance) =>
    <String, dynamic>{
      'state': _$SessionStateEnumMap[instance.state]!,
      'userId': instance.userId,
      'familyId': instance.familyId,
      'memberId': instance.memberId,
      'role': _$FamilyRoleEnumMap[instance.role],
      'callName': instance.callName,
      'authMethod': _$AuthMethodEnumMap[instance.authMethod],
      'phone': instance.phone,
      'stage': _$FamilyStageEnumMap[instance.stage],
      'pendingInvite': instance.pendingInvite?.toJson(),
    };

const _$SessionStateEnumMap = {
  SessionState.signedOut: 'signedOut',
  SessionState.needsProfile: 'needsProfile',
  SessionState.needsRole: 'needsRole',
  SessionState.needsFamily: 'needsFamily',
  SessionState.waitingPartner: 'waitingPartner',
  SessionState.activatedSetup: 'activatedSetup',
  SessionState.active: 'active',
  SessionState.circleWaiting: 'circleWaiting',
  SessionState.circleActive: 'circleActive',
  SessionState.expired: 'expired',
};

const _$FamilyRoleEnumMap = {
  FamilyRole.father: 'father',
  FamilyRole.mother: 'mother',
  FamilyRole.relative: 'relative',
};

const _$AuthMethodEnumMap = {
  AuthMethod.apple: 'apple',
  AuthMethod.google: 'google',
  AuthMethod.phone: 'phone',
};

const _$FamilyStageEnumMap = {
  FamilyStage.pregnant: 'pregnant',
  FamilyStage.born: 'born',
  FamilyStage.both: 'both',
};
