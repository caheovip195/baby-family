// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChildRecord _$ChildRecordFromJson(Map<String, dynamic> json) => _ChildRecord(
  id: json['id'] as String?,
  familyId: json['familyId'] as String?,
  name: json['name'] as String?,
  nickname: json['nickname'] as String?,
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  birthTime: json['birthTime'] as String?,
  gender: json['gender'] as String?,
  colorIndex: (json['colorIndex'] as num?)?.toInt(),
  status: json['status'] as String?,
);

Map<String, dynamic> _$ChildRecordToJson(_ChildRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'name': instance.name,
      'nickname': instance.nickname,
      'birthDate': instance.birthDate?.toIso8601String(),
      'birthTime': instance.birthTime,
      'gender': instance.gender,
      'colorIndex': instance.colorIndex,
      'status': instance.status,
    };
