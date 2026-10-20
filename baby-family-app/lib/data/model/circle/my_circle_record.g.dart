// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_circle_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyCircleRecord _$MyCircleRecordFromJson(Map<String, dynamic> json) =>
    _MyCircleRecord(
      familyId: json['familyId'] as String?,
      familyName: json['familyName'] as String?,
      status: json['status'] as String?,
      children:
          (json['children'] as List<dynamic>?)
              ?.map(
                (e) => CircleSubjectRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <CircleSubjectRecord>[],
      allowDownload: json['allowDownload'] as bool? ?? false,
    );

Map<String, dynamic> _$MyCircleRecordToJson(_MyCircleRecord instance) =>
    <String, dynamic>{
      'familyId': instance.familyId,
      'familyName': instance.familyName,
      'status': instance.status,
      'children': instance.children.map((e) => e.toJson()).toList(),
      'allowDownload': instance.allowDownload,
    };
