// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_decision.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InviteDecision _$InviteDecisionFromJson(Map<String, dynamic> json) =>
    _InviteDecision(
      status: json['status'] as String?,
      familyId: json['familyId'] as String?,
      trialEndsAt: json['trialEndsAt'] == null
          ? null
          : DateTime.parse(json['trialEndsAt'] as String),
    );

Map<String, dynamic> _$InviteDecisionToJson(_InviteDecision instance) =>
    <String, dynamic>{
      'status': instance.status,
      'familyId': instance.familyId,
      'trialEndsAt': instance.trialEndsAt?.toIso8601String(),
    };
