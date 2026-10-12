// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChapterSummary _$ChapterSummaryFromJson(Map<String, dynamic> json) =>
    _ChapterSummary(
      childId: json['childId'] as String,
      monthIndex: (json['monthIndex'] as num).toInt(),
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      memoryCount: (json['memoryCount'] as num?)?.toInt() ?? 0,
      firstsCount: (json['firstsCount'] as num?)?.toInt() ?? 0,
      voiceCount: (json['voiceCount'] as num?)?.toInt() ?? 0,
      hasMonthlyPhoto: json['hasMonthlyPhoto'] as bool? ?? false,
      coverAsset: json['coverAsset'] as String?,
      current: json['current'] as bool? ?? false,
    );

Map<String, dynamic> _$ChapterSummaryToJson(_ChapterSummary instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'monthIndex': instance.monthIndex,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'memoryCount': instance.memoryCount,
      'firstsCount': instance.firstsCount,
      'voiceCount': instance.voiceCount,
      'hasMonthlyPhoto': instance.hasMonthlyPhoto,
      'coverAsset': instance.coverAsset,
      'current': instance.current,
    };
