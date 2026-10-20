// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_export_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DataExportRecord _$DataExportRecordFromJson(Map<String, dynamic> json) =>
    _DataExportRecord(
      id: json['id'] as String?,
      scope: json['scope'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      errorCode: json['errorCode'] as String?,
      download: json['download'] == null
          ? null
          : ExportDownloadRecord.fromJson(
              json['download'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$DataExportRecordToJson(_DataExportRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scope': instance.scope,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'errorCode': instance.errorCode,
      'download': instance.download?.toJson(),
    };
