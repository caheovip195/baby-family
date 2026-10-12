// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bridge_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BridgeSession _$BridgeSessionFromJson(Map<String, dynamic> json) =>
    _BridgeSession(
      id: json['id'] as String,
      status:
          $enumDecodeNullable(_$BridgeStatusEnumMap, json['status']) ??
          BridgeStatus.draft,
      initiatorUserId: json['initiatorUserId'] as String,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      wizardStep: (json['wizardStep'] as num?)?.toInt() ?? 1,
      privateNote: json['privateNote'] as String?,
      shares:
          (json['shares'] as List<dynamic>?)
              ?.map((e) => BridgeShare.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nextStep: json['nextStep'] == null
          ? null
          : BridgeNextStep.fromJson(json['nextStep'] as Map<String, dynamic>),
      closeAgreedUserIds:
          (json['closeAgreedUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      retentionDays: (json['retentionDays'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$BridgeSessionToJson(_BridgeSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$BridgeStatusEnumMap[instance.status]!,
      'initiatorUserId': instance.initiatorUserId,
      'startedAt': instance.startedAt?.toIso8601String(),
      'wizardStep': instance.wizardStep,
      'privateNote': instance.privateNote,
      'shares': instance.shares.map((e) => e.toJson()).toList(),
      'nextStep': instance.nextStep?.toJson(),
      'closeAgreedUserIds': instance.closeAgreedUserIds,
      'retentionDays': instance.retentionDays,
    };

const _$BridgeStatusEnumMap = {
  BridgeStatus.draft: 'draft',
  BridgeStatus.invited: 'invited',
  BridgeStatus.active: 'active',
  BridgeStatus.nextStep: 'nextStep',
  BridgeStatus.closed: 'closed',
  BridgeStatus.paused: 'paused',
};
