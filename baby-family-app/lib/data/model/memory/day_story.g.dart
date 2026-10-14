// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayStory _$DayStoryFromJson(Map<String, dynamic> json) => _DayStory(
  date: DateTime.parse(json['date'] as String),
  childId: json['childId'] as String,
  title: json['title'] as String? ?? '',
  body: json['body'] as String? ?? '',
  aiGenerated: json['aiGenerated'] as bool? ?? true,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => DayStoryItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  photoAssets:
      (json['photoAssets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  photoOptions:
      (json['photoOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  coverAsset: json['coverAsset'] as String?,
  visibility:
      $enumDecodeNullable(_$MemoryVisibilityEnumMap, json['visibility']) ??
      MemoryVisibility.parents,
);

Map<String, dynamic> _$DayStoryToJson(_DayStory instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'childId': instance.childId,
  'title': instance.title,
  'body': instance.body,
  'aiGenerated': instance.aiGenerated,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'photoAssets': instance.photoAssets,
  'photoOptions': instance.photoOptions,
  'coverAsset': instance.coverAsset,
  'visibility': _$MemoryVisibilityEnumMap[instance.visibility]!,
};

const _$MemoryVisibilityEnumMap = {
  MemoryVisibility.family: 'family',
  MemoryVisibility.parents: 'parents',
  MemoryVisibility.onlyMe: 'onlyMe',
};
