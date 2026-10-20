// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_download_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExportDownloadRecord _$ExportDownloadRecordFromJson(
  Map<String, dynamic> json,
) => _ExportDownloadRecord(
  url: json['url'] as String?,
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$ExportDownloadRecordToJson(
  _ExportDownloadRecord instance,
) => <String, dynamic>{
  'url': instance.url,
  'expiresAt': instance.expiresAt?.toIso8601String(),
};
