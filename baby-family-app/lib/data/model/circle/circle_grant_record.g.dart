// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_grant_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircleGrantRecord _$CircleGrantRecordFromJson(Map<String, dynamic> json) =>
    _CircleGrantRecord(
      childId: json['childId'] as String?,
      pregnancyId: json['pregnancyId'] as String?,
      allowDownload: json['allowDownload'] as bool? ?? false,
      permission: json['permission'] as String?,
    );

Map<String, dynamic> _$CircleGrantRecordToJson(_CircleGrantRecord instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'pregnancyId': instance.pregnancyId,
      'allowDownload': instance.allowDownload,
      'permission': instance.permission,
    };
