// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_export_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DataExportJob _$DataExportJobFromJson(Map<String, dynamic> json) =>
    _DataExportJob(
      kind: $enumDecode(_$DataExportKindEnumMap, json['kind']),
      status:
          $enumDecodeNullable(_$DataExportStatusEnumMap, json['status']) ??
          DataExportStatus.idle,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      sizeMb: (json['sizeMb'] as num?)?.toInt(),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$DataExportJobToJson(_DataExportJob instance) =>
    <String, dynamic>{
      'kind': _$DataExportKindEnumMap[instance.kind]!,
      'status': _$DataExportStatusEnumMap[instance.status]!,
      'progress': instance.progress,
      'startedAt': instance.startedAt?.toIso8601String(),
      'sizeMb': instance.sizeMb,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$DataExportKindEnumMap = {
  DataExportKind.personal: 'personal',
  DataExportKind.family: 'family',
};

const _$DataExportStatusEnumMap = {
  DataExportStatus.idle: 'idle',
  DataExportStatus.preparing: 'preparing',
  DataExportStatus.ready: 'ready',
};
