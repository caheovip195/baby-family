// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bootstrap_family.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BootstrapFamily _$BootstrapFamilyFromJson(Map<String, dynamic> json) =>
    _BootstrapFamily(
      id: json['id'] as String?,
      name: json['name'] as String?,
      status: json['status'] as String?,
      timezone: json['timezone'] as String?,
      activatedAt: json['activatedAt'] == null
          ? null
          : DateTime.parse(json['activatedAt'] as String),
    );

Map<String, dynamic> _$BootstrapFamilyToJson(_BootstrapFamily instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'timezone': instance.timezone,
      'activatedAt': instance.activatedAt?.toIso8601String(),
    };
