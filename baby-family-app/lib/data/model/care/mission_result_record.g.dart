// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_result_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionResultRecord _$MissionResultRecordFromJson(Map<String, dynamic> json) =>
    _MissionResultRecord(
      mission: json['mission'] == null
          ? null
          : MissionRecord.fromJson(json['mission'] as Map<String, dynamic>),
      myHeartsAwarded: (json['myHeartsAwarded'] as num?)?.toInt(),
      removedId: json['removedId'] as String?,
    );

Map<String, dynamic> _$MissionResultRecordToJson(
  _MissionResultRecord instance,
) => <String, dynamic>{
  'mission': instance.mission?.toJson(),
  'myHeartsAwarded': instance.myHeartsAwarded,
  'removedId': instance.removedId,
};
