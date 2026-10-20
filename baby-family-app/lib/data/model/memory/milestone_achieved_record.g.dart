// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_achieved_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MilestoneAchievedRecord _$MilestoneAchievedRecordFromJson(
  Map<String, dynamic> json,
) => _MilestoneAchievedRecord(
  milestoneId: json['milestoneId'] as String?,
  memoryId: json['memoryId'] as String?,
  occurredOn: json['occurredOn'] == null
      ? null
      : DateTime.parse(json['occurredOn'] as String),
);

Map<String, dynamic> _$MilestoneAchievedRecordToJson(
  _MilestoneAchievedRecord instance,
) => <String, dynamic>{
  'milestoneId': instance.milestoneId,
  'memoryId': instance.memoryId,
  'occurredOn': instance.occurredOn?.toIso8601String(),
};
