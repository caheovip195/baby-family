// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_billing_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyBillingUsage _$FamilyBillingUsageFromJson(Map<String, dynamic> json) =>
    _FamilyBillingUsage(
      storageBytes: json['storageBytes'] as String?,
      memoryCount: (json['memoryCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FamilyBillingUsageToJson(_FamilyBillingUsage instance) =>
    <String, dynamic>{
      'storageBytes': instance.storageBytes,
      'memoryCount': instance.memoryCount,
    };
