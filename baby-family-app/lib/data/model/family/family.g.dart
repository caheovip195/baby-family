// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Family _$FamilyFromJson(Map<String, dynamic> json) => _Family(
  id: json['id'] as String,
  name: json['name'] as String,
  coverIndex: (json['coverIndex'] as num?)?.toInt() ?? 0,
  coverAsset: json['coverAsset'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  activatedAt: json['activatedAt'] == null
      ? null
      : DateTime.parse(json['activatedAt'] as String),
  setupCompleted: json['setupCompleted'] as bool? ?? false,
  timezone: json['timezone'] as String?,
  plan: json['plan'] == null
      ? const PlanInfo()
      : PlanInfo.fromJson(json['plan'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FamilyToJson(_Family instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'coverIndex': instance.coverIndex,
  'coverAsset': instance.coverAsset,
  'createdAt': instance.createdAt?.toIso8601String(),
  'activatedAt': instance.activatedAt?.toIso8601String(),
  'setupCompleted': instance.setupCompleted,
  'timezone': instance.timezone,
  'plan': instance.plan.toJson(),
};
