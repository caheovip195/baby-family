// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_recap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeeklyRecap _$WeeklyRecapFromJson(Map<String, dynamic> json) => _WeeklyRecap(
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  headline: json['headline'] as String? ?? '',
  moments: (json['moments'] as num?)?.toInt() ?? 0,
  firsts: (json['firsts'] as num?)?.toInt() ?? 0,
  quotes: (json['quotes'] as num?)?.toInt() ?? 0,
  heroAssets:
      (json['heroAssets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  highlights:
      (json['highlights'] as List<dynamic>?)
          ?.map((e) => Memory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  togetherTitle: json['togetherTitle'] as String?,
  togetherBody: json['togetherBody'] as String?,
  pageCount: (json['pageCount'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$WeeklyRecapToJson(_WeeklyRecap instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'headline': instance.headline,
      'moments': instance.moments,
      'firsts': instance.firsts,
      'quotes': instance.quotes,
      'heroAssets': instance.heroAssets,
      'highlights': instance.highlights.map((e) => e.toJson()).toList(),
      'togetherTitle': instance.togetherTitle,
      'togetherBody': instance.togetherBody,
      'pageCount': instance.pageCount,
    };
