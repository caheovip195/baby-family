// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_item_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimelineItemRecord _$TimelineItemRecordFromJson(Map<String, dynamic> json) =>
    _TimelineItemRecord(
      type: json['type'] as String?,
      memory: json['memory'] == null
          ? null
          : MemoryRecord.fromJson(json['memory'] as Map<String, dynamic>),
      id: json['id'] as String?,
      kind: json['kind'] as String?,
      childId: json['childId'] as String?,
      monthIndex: (json['monthIndex'] as num?)?.toInt(),
      date: json['date'] as String?,
      coverUrl: json['coverUrl'] as String?,
      memoryCount: (json['memoryCount'] as num?)?.toInt(),
      firstsCount: (json['firstsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TimelineItemRecordToJson(_TimelineItemRecord instance) =>
    <String, dynamic>{
      'type': instance.type,
      'memory': instance.memory?.toJson(),
      'id': instance.id,
      'kind': instance.kind,
      'childId': instance.childId,
      'monthIndex': instance.monthIndex,
      'date': instance.date,
      'coverUrl': instance.coverUrl,
      'memoryCount': instance.memoryCount,
      'firstsCount': instance.firstsCount,
    };
