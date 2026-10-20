// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionRecord _$MissionRecordFromJson(Map<String, dynamic> json) =>
    _MissionRecord(
      id: json['id'] as String?,
      boardDate: json['boardDate'] as String?,
      ownerKind: json['ownerKind'] as String?,
      mine: json['mine'] as bool?,
      source: json['source'] as String?,
      templateId: json['templateId'] as String?,
      title: json['title'] as String?,
      note: json['note'] as String?,
      category: json['category'] as String?,
      childIds:
          (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      hearts: (json['hearts'] as num?)?.toInt(),
      status: json['status'] as String?,
      scheduledTime: json['scheduledTime'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      late: json['late'] as bool? ?? false,
      thanked: json['thanked'] as bool? ?? false,
      canSwap: json['canSwap'] as bool? ?? false,
      version: (json['version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MissionRecordToJson(_MissionRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'boardDate': instance.boardDate,
      'ownerKind': instance.ownerKind,
      'mine': instance.mine,
      'source': instance.source,
      'templateId': instance.templateId,
      'title': instance.title,
      'note': instance.note,
      'category': instance.category,
      'childIds': instance.childIds,
      'hearts': instance.hearts,
      'status': instance.status,
      'scheduledTime': instance.scheduledTime,
      'completedAt': instance.completedAt?.toIso8601String(),
      'late': instance.late,
      'thanked': instance.thanked,
      'canSwap': instance.canSwap,
      'version': instance.version,
    };
