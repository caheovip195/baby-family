// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanInfo _$PlanInfoFromJson(Map<String, dynamic> json) => _PlanInfo(
  state:
      $enumDecodeNullable(_$PlanStateEnumMap, json['state']) ?? PlanState.trial,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  endsAt: json['endsAt'] == null
      ? null
      : DateTime.parse(json['endsAt'] as String),
  storageUsedMb: (json['storageUsedMb'] as num?)?.toInt() ?? 0,
  storageQuotaMb: (json['storageQuotaMb'] as num?)?.toInt() ?? 0,
  relativeSlotsUsed: (json['relativeSlotsUsed'] as num?)?.toInt() ?? 0,
  relativeSlotsMax: (json['relativeSlotsMax'] as num?)?.toInt() ?? 0,
  paymentIssue: json['paymentIssue'] as bool? ?? false,
);

Map<String, dynamic> _$PlanInfoToJson(_PlanInfo instance) => <String, dynamic>{
  'state': _$PlanStateEnumMap[instance.state]!,
  'startedAt': instance.startedAt?.toIso8601String(),
  'endsAt': instance.endsAt?.toIso8601String(),
  'storageUsedMb': instance.storageUsedMb,
  'storageQuotaMb': instance.storageQuotaMb,
  'relativeSlotsUsed': instance.relativeSlotsUsed,
  'relativeSlotsMax': instance.relativeSlotsMax,
  'paymentIssue': instance.paymentIssue,
};

const _$PlanStateEnumMap = {
  PlanState.trial: 'trial',
  PlanState.house: 'house',
  PlanState.family: 'family',
  PlanState.expired: 'expired',
};
