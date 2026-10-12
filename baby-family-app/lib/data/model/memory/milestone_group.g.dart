// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MilestoneGroup _$MilestoneGroupFromJson(Map<String, dynamic> json) =>
    _MilestoneGroup(
      code: json['code'] as String,
      emoji: json['emoji'] as String? ?? '',
      title: json['title'] as String,
    );

Map<String, dynamic> _$MilestoneGroupToJson(_MilestoneGroup instance) =>
    <String, dynamic>{
      'code': instance.code,
      'emoji': instance.emoji,
      'title': instance.title,
    };
