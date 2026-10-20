// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_recap_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeeklyRecapRecord _$WeeklyRecapRecordFromJson(Map<String, dynamic> json) =>
    _WeeklyRecapRecord(
      id: json['id'] as String?,
      periodStart: json['periodStart'] as String?,
      periodEnd: json['periodEnd'] as String?,
      visibility: json['visibility'] as String?,
      content: json['content'] == null
          ? null
          : WeeklyRecapContent.fromJson(
              json['content'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$WeeklyRecapRecordToJson(_WeeklyRecapRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'periodStart': instance.periodStart,
      'periodEnd': instance.periodEnd,
      'visibility': instance.visibility,
      'content': instance.content?.toJson(),
    };

_WeeklyRecapContent _$WeeklyRecapContentFromJson(Map<String, dynamic> json) =>
    _WeeklyRecapContent(
      version: (json['version'] as num?)?.toInt(),
      stats: json['stats'] == null
          ? null
          : WeekStatsRecord.fromJson(json['stats'] as Map<String, dynamic>),
      topMemories:
          (json['topMemories'] as List<dynamic>?)
              ?.map((e) => RecapMemoryRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RecapMemoryRef>[],
    );

Map<String, dynamic> _$WeeklyRecapContentToJson(_WeeklyRecapContent instance) =>
    <String, dynamic>{
      'version': instance.version,
      'stats': instance.stats?.toJson(),
      'topMemories': instance.topMemories.map((e) => e.toJson()).toList(),
    };

_RecapMemoryRef _$RecapMemoryRefFromJson(Map<String, dynamic> json) =>
    _RecapMemoryRef(id: json['id'] as String?);

Map<String, dynamic> _$RecapMemoryRefToJson(_RecapMemoryRef instance) =>
    <String, dynamic>{'id': instance.id};
