// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportRecord _$ReportRecordFromJson(Map<String, dynamic> json) =>
    _ReportRecord(
      id: json['id'] as String?,
      code: json['code'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReportRecordToJson(_ReportRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
