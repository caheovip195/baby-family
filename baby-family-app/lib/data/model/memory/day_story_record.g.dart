// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_story_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayStoryRecord _$DayStoryRecordFromJson(Map<String, dynamic> json) =>
    _DayStoryRecord(
      childId: json['childId'] as String?,
      date: json['date'] as String?,
      memories: json['memories'] == null
          ? const <DayStoryMemoryRecord>[]
          : _dayMemories(json['memories']),
      saved: json['saved'] == null
          ? null
          : SavedDayStoryRecord.fromJson(json['saved'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DayStoryRecordToJson(_DayStoryRecord instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'date': instance.date,
      'memories': instance.memories.map((e) => e.toJson()).toList(),
      'saved': instance.saved?.toJson(),
    };

_DayStoryMemoryRecord _$DayStoryMemoryRecordFromJson(
  Map<String, dynamic> json,
) => _DayStoryMemoryRecord(
  memoryId: json['memoryId'] as String,
  kind: json['kind'] as String?,
  title: json['title'] as String?,
  occurredAt: json['occurredAt'] == null
      ? null
      : DateTime.parse(json['occurredAt'] as String),
  assetIds:
      (json['assetIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$DayStoryMemoryRecordToJson(
  _DayStoryMemoryRecord instance,
) => <String, dynamic>{
  'memoryId': instance.memoryId,
  'kind': instance.kind,
  'title': instance.title,
  'occurredAt': instance.occurredAt?.toIso8601String(),
  'assetIds': instance.assetIds,
};

_SavedDayStoryRecord _$SavedDayStoryRecordFromJson(
  Map<String, dynamic> json,
) => _SavedDayStoryRecord(
  id: json['id'] as String?,
  title: json['title'] as String? ?? '',
  body: json['body'] as String?,
  coverAssetId: json['coverAssetId'] as String?,
  memoryIds:
      (json['memoryIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  assetIds:
      (json['assetIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  visibility: json['visibility'] as String?,
);

Map<String, dynamic> _$SavedDayStoryRecordToJson(
  _SavedDayStoryRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'coverAssetId': instance.coverAssetId,
  'memoryIds': instance.memoryIds,
  'assetIds': instance.assetIds,
  'visibility': instance.visibility,
};
