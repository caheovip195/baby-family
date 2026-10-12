// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hearts_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeartsSummary _$HeartsSummaryFromJson(Map<String, dynamic> json) =>
    _HeartsSummary(
      today: (json['today'] as num?)?.toInt() ?? 0,
      week: (json['week'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      recent:
          (json['recent'] as List<dynamic>?)
              ?.map((e) => HeartsEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$HeartsSummaryToJson(_HeartsSummary instance) =>
    <String, dynamic>{
      'today': instance.today,
      'week': instance.week,
      'total': instance.total,
      'recent': instance.recent.map((e) => e.toJson()).toList(),
    };
