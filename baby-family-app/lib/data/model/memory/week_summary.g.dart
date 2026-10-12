// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeekSummary _$WeekSummaryFromJson(Map<String, dynamic> json) => _WeekSummary(
  moments: (json['moments'] as num?)?.toInt() ?? 0,
  firsts: (json['firsts'] as num?)?.toInt() ?? 0,
  quotes: (json['quotes'] as num?)?.toInt() ?? 0,
  thumbnails:
      (json['thumbnails'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$WeekSummaryToJson(_WeekSummary instance) =>
    <String, dynamic>{
      'moments': instance.moments,
      'firsts': instance.firsts,
      'quotes': instance.quotes,
      'thumbnails': instance.thumbnails,
    };
