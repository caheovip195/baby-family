// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prep_item_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrepItemRecord _$PrepItemRecordFromJson(Map<String, dynamic> json) =>
    _PrepItemRecord(
      id: json['id'] as String?,
      pregnancyId: json['pregnancyId'] as String?,
      groupCode: json['groupCode'] as String?,
      title: json['title'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      done: json['done'] as bool? ?? false,
    );

Map<String, dynamic> _$PrepItemRecordToJson(_PrepItemRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pregnancyId': instance.pregnancyId,
      'groupCode': instance.groupCode,
      'title': instance.title,
      'sortOrder': instance.sortOrder,
      'done': instance.done,
    };
