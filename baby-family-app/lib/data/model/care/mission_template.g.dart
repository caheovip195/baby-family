// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionTemplate _$MissionTemplateFromJson(Map<String, dynamic> json) =>
    _MissionTemplate(
      id: json['id'] as String,
      title: json['title'] as String,
      category:
          $enumDecodeNullable(_$MissionCategoryEnumMap, json['category']) ??
          MissionCategory.care,
      hearts: (json['hearts'] as num?)?.toInt() ?? 0,
      durationMin: (json['durationMin'] as num?)?.toInt(),
      icon: json['icon'] as String?,
      hint: json['hint'] as String?,
      forPregnancy: json['forPregnancy'] as bool? ?? false,
      perChild: json['perChild'] as bool? ?? true,
    );

Map<String, dynamic> _$MissionTemplateToJson(_MissionTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': _$MissionCategoryEnumMap[instance.category]!,
      'hearts': instance.hearts,
      'durationMin': instance.durationMin,
      'icon': instance.icon,
      'hint': instance.hint,
      'forPregnancy': instance.forPregnancy,
      'perChild': instance.perChild,
    };

const _$MissionCategoryEnumMap = {
  MissionCategory.care: 'care',
  MissionCategory.bonding: 'bonding',
  MissionCategory.outing: 'outing',
  MissionCategory.memory: 'memory',
  MissionCategory.support: 'support',
  MissionCategory.self: 'self',
  MissionCategory.together: 'together',
  MissionCategory.couple: 'couple',
  MissionCategory.custom: 'custom',
};
