// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_story_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodayStoryRecord _$TodayStoryRecordFromJson(Map<String, dynamic> json) =>
    _TodayStoryRecord(
      date: json['date'] as String?,
      childId: json['childId'] as String?,
      memoryCount: (json['memoryCount'] as num?)?.toInt() ?? 0,
      slides:
          (json['slides'] as List<dynamic>?)
              ?.map(
                (e) =>
                    TodayStorySlideRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <TodayStorySlideRecord>[],
    );

Map<String, dynamic> _$TodayStoryRecordToJson(_TodayStoryRecord instance) =>
    <String, dynamic>{
      'date': instance.date,
      'childId': instance.childId,
      'memoryCount': instance.memoryCount,
      'slides': instance.slides.map((e) => e.toJson()).toList(),
    };

_TodayStorySlideRecord _$TodayStorySlideRecordFromJson(
  Map<String, dynamic> json,
) => _TodayStorySlideRecord(
  memoryId: json['memoryId'] as String?,
  kind: json['kind'] as String?,
  imageUrl: json['imageUrl'] as String?,
  videoUrl: json['videoUrl'] as String?,
  caption: json['caption'] as String?,
  occurredAt: json['occurredAt'] == null
      ? null
      : DateTime.parse(json['occurredAt'] as String),
);

Map<String, dynamic> _$TodayStorySlideRecordToJson(
  _TodayStorySlideRecord instance,
) => <String, dynamic>{
  'memoryId': instance.memoryId,
  'kind': instance.kind,
  'imageUrl': instance.imageUrl,
  'videoUrl': instance.videoUrl,
  'caption': instance.caption,
  'occurredAt': instance.occurredAt?.toIso8601String(),
};
