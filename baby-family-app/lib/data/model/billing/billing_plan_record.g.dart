// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_plan_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillingPlanRecord _$BillingPlanRecordFromJson(Map<String, dynamic> json) =>
    _BillingPlanRecord(
      code: json['code'] as String?,
      displayName:
          (json['displayName'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      version: (json['version'] as num?)?.toInt(),
      quotas:
          (json['quotas'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as num),
          ) ??
          const <String, num>{},
      features:
          (json['features'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const <String, bool>{},
    );

Map<String, dynamic> _$BillingPlanRecordToJson(_BillingPlanRecord instance) =>
    <String, dynamic>{
      'code': instance.code,
      'displayName': instance.displayName,
      'displayOrder': instance.displayOrder,
      'version': instance.version,
      'quotas': instance.quotas,
      'features': instance.features,
    };
