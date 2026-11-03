// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_recap_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthRecapRecord _$MonthRecapRecordFromJson(Map<String, dynamic> json) =>
    _MonthRecapRecord(
      childId: json['childId'] as String?,
      monthIndex: (json['monthIndex'] as num?)?.toInt(),
      start: json['start'] as String?,
      end: json['end'] as String?,
      moments: (json['moments'] as num?)?.toInt() ?? 0,
      firsts: (json['firsts'] as num?)?.toInt() ?? 0,
      voices: (json['voices'] as num?)?.toInt() ?? 0,
      firstMemoryIds:
          (json['firstMemoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      voiceMemoryIds:
          (json['voiceMemoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$MonthRecapRecordToJson(_MonthRecapRecord instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'monthIndex': instance.monthIndex,
      'start': instance.start,
      'end': instance.end,
      'moments': instance.moments,
      'firsts': instance.firsts,
      'voices': instance.voices,
      'firstMemoryIds': instance.firstMemoryIds,
      'voiceMemoryIds': instance.voiceMemoryIds,
    };
