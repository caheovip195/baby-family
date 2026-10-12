// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_recap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthRecap _$MonthRecapFromJson(Map<String, dynamic> json) => _MonthRecap(
  childId: json['childId'] as String,
  monthIndex: (json['monthIndex'] as num).toInt(),
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  headline: json['headline'] as String? ?? '',
  moments: (json['moments'] as num?)?.toInt() ?? 0,
  firsts: (json['firsts'] as num?)?.toInt() ?? 0,
  voices: (json['voices'] as num?)?.toInt() ?? 0,
  previousPhotoAsset: json['previousPhotoAsset'] as String?,
  currentPhotoAsset: json['currentPhotoAsset'] as String?,
  firstMemories:
      (json['firstMemories'] as List<dynamic>?)
          ?.map((e) => Memory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  voiceMemories:
      (json['voiceMemories'] as List<dynamic>?)
          ?.map((e) => Memory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pageCount: (json['pageCount'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$MonthRecapToJson(_MonthRecap instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'monthIndex': instance.monthIndex,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'headline': instance.headline,
      'moments': instance.moments,
      'firsts': instance.firsts,
      'voices': instance.voices,
      'previousPhotoAsset': instance.previousPhotoAsset,
      'currentPhotoAsset': instance.currentPhotoAsset,
      'firstMemories': instance.firstMemories.map((e) => e.toJson()).toList(),
      'voiceMemories': instance.voiceMemories.map((e) => e.toJson()).toList(),
      'pageCount': instance.pageCount,
    };
