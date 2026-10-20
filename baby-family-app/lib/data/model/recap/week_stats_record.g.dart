// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_stats_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeekStatsRecord _$WeekStatsRecordFromJson(Map<String, dynamic> json) =>
    _WeekStatsRecord(
      weekStart: json['weekStart'] as String?,
      memoryCount: (json['memoryCount'] as num?)?.toInt() ?? 0,
      photoCount: (json['photoCount'] as num?)?.toInt() ?? 0,
      videoCount: (json['videoCount'] as num?)?.toInt() ?? 0,
      milestoneCount: (json['milestoneCount'] as num?)?.toInt() ?? 0,
      missionsDone: (json['missionsDone'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WeekStatsRecordToJson(_WeekStatsRecord instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart,
      'memoryCount': instance.memoryCount,
      'photoCount': instance.photoCount,
      'videoCount': instance.videoCount,
      'milestoneCount': instance.milestoneCount,
      'missionsDone': instance.missionsDone,
    };
