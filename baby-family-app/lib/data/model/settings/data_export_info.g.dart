// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_export_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DataExportInfo _$DataExportInfoFromJson(Map<String, dynamic> json) =>
    _DataExportInfo(
      jobs:
          (json['jobs'] as List<dynamic>?)
              ?.map((e) => DataExportJob.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cacheMb: (json['cacheMb'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DataExportInfoToJson(_DataExportInfo instance) =>
    <String, dynamic>{
      'jobs': instance.jobs.map((e) => e.toJson()).toList(),
      'cacheMb': instance.cacheMb,
    };
