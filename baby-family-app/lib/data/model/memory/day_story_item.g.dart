// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_story_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayStoryItem _$DayStoryItemFromJson(Map<String, dynamic> json) =>
    _DayStoryItem(
      id: json['id'] as String,
      title: json['title'] as String,
      kindCode: json['kindCode'] as String? ?? 'photo',
      time: json['time'] as String?,
      icon: json['icon'] as String?,
      selected: json['selected'] as bool? ?? true,
    );

Map<String, dynamic> _$DayStoryItemToJson(_DayStoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'kindCode': instance.kindCode,
      'time': instance.time,
      'icon': instance.icon,
      'selected': instance.selected,
    };
