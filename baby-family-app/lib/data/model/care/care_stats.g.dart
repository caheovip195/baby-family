// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CareStats _$CareStatsFromJson(Map<String, dynamic> json) => _CareStats(
  weekStart: DateTime.parse(json['weekStart'] as String),
  weekEnd: DateTime.parse(json['weekEnd'] as String),
  total: (json['total'] as num?)?.toInt() ?? 0,
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryCount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  bloomDays: (json['bloomDays'] as num?)?.toInt() ?? 0,
  bloomed:
      (json['bloomed'] as List<dynamic>?)?.map((e) => e as bool).toList() ??
      const [],
);

Map<String, dynamic> _$CareStatsToJson(_CareStats instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart.toIso8601String(),
      'weekEnd': instance.weekEnd.toIso8601String(),
      'total': instance.total,
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'bloomDays': instance.bloomDays,
      'bloomed': instance.bloomed,
    };
