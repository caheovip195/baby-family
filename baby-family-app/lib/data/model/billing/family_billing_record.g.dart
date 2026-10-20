// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_billing_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyBillingRecord _$FamilyBillingRecordFromJson(Map<String, dynamic> json) =>
    _FamilyBillingRecord(
      accessPhase: json['accessPhase'] as String?,
      licenseBlocked: json['licenseBlocked'] as bool? ?? false,
      plan: json['plan'] == null
          ? null
          : BillingPlanRecord.fromJson(json['plan'] as Map<String, dynamic>),
      trialEndsAt: json['trialEndsAt'] == null
          ? null
          : DateTime.parse(json['trialEndsAt'] as String),
      validUntil: json['validUntil'] == null
          ? null
          : DateTime.parse(json['validUntil'] as String),
      inGrace: json['inGrace'] as bool? ?? false,
      usage: json['usage'] == null
          ? null
          : FamilyBillingUsage.fromJson(json['usage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FamilyBillingRecordToJson(
  _FamilyBillingRecord instance,
) => <String, dynamic>{
  'accessPhase': instance.accessPhase,
  'licenseBlocked': instance.licenseBlocked,
  'plan': instance.plan?.toJson(),
  'trialEndsAt': instance.trialEndsAt?.toIso8601String(),
  'validUntil': instance.validUntil?.toIso8601String(),
  'inGrace': instance.inGrace,
  'usage': instance.usage?.toJson(),
};
