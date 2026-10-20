// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bootstrap_entitlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BootstrapEntitlement _$BootstrapEntitlementFromJson(
  Map<String, dynamic> json,
) => _BootstrapEntitlement(
  accessPhase: json['accessPhase'] as String?,
  trialEndsAt: json['trialEndsAt'] == null
      ? null
      : DateTime.parse(json['trialEndsAt'] as String),
  validUntil: json['validUntil'] == null
      ? null
      : DateTime.parse(json['validUntil'] as String),
);

Map<String, dynamic> _$BootstrapEntitlementToJson(
  _BootstrapEntitlement instance,
) => <String, dynamic>{
  'accessPhase': instance.accessPhase,
  'trialEndsAt': instance.trialEndsAt?.toIso8601String(),
  'validUntil': instance.validUntil?.toIso8601String(),
};
