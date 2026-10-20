// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_stats_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChildStatsRecord _$ChildStatsRecordFromJson(Map<String, dynamic> json) =>
    _ChildStatsRecord(
      memoryCount: (json['memoryCount'] as num?)?.toInt() ?? 0,
      milestoneCount: (json['milestoneCount'] as num?)?.toInt() ?? 0,
      photoCount: (json['photoCount'] as num?)?.toInt() ?? 0,
      firstMemoryAt: json['firstMemoryAt'] == null
          ? null
          : DateTime.parse(json['firstMemoryAt'] as String),
    );

Map<String, dynamic> _$ChildStatsRecordToJson(_ChildStatsRecord instance) =>
    <String, dynamic>{
      'memoryCount': instance.memoryCount,
      'milestoneCount': instance.milestoneCount,
      'photoCount': instance.photoCount,
      'firstMemoryAt': instance.firstMemoryAt?.toIso8601String(),
    };
