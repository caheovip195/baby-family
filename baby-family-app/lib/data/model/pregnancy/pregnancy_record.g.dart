// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnancy_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PregnancyRecord _$PregnancyRecordFromJson(Map<String, dynamic> json) =>
    _PregnancyRecord(
      id: json['id'] as String?,
      familyId: json['familyId'] as String?,
      seqNo: (json['seqNo'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      expectedCount: (json['expectedCount'] as num?)?.toInt(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$PregnancyRecordToJson(_PregnancyRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'seqNo': instance.seqNo,
      'nickname': instance.nickname,
      'dueDate': instance.dueDate?.toIso8601String(),
      'expectedCount': instance.expectedCount,
      'status': instance.status,
    };
