// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_subject_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircleSubjectRecord _$CircleSubjectRecordFromJson(Map<String, dynamic> json) =>
    _CircleSubjectRecord(
      id: json['id'] as String?,
      name: json['name'] as String?,
      kind: json['kind'] as String?,
      permission: json['permission'] as String?,
      allowDownload: json['allowDownload'] as bool?,
    );

Map<String, dynamic> _$CircleSubjectRecordToJson(
  _CircleSubjectRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'kind': instance.kind,
  'permission': instance.permission,
  'allowDownload': instance.allowDownload,
};
