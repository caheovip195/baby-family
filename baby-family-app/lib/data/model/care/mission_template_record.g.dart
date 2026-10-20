// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_template_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionTemplateRecord _$MissionTemplateRecordFromJson(
  Map<String, dynamic> json,
) => _MissionTemplateRecord(
  id: json['id'] as String?,
  title: json['title'] as String?,
  category: json['category'] as String?,
  hearts: (json['hearts'] as num?)?.toInt() ?? 0,
  durationMin: (json['durationMin'] as num?)?.toInt(),
  multiChildOk: json['multiChildOk'] as bool? ?? true,
);

Map<String, dynamic> _$MissionTemplateRecordToJson(
  _MissionTemplateRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'category': instance.category,
  'hearts': instance.hearts,
  'durationMin': instance.durationMin,
  'multiChildOk': instance.multiChildOk,
};
