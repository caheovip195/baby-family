// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MilestoneOption _$MilestoneOptionFromJson(Map<String, dynamic> json) =>
    _MilestoneOption(
      code: json['code'] as String,
      group: json['group'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String?,
      recordedAt: json['recordedAt'] == null
          ? null
          : DateTime.parse(json['recordedAt'] as String),
      expectedDate: json['expectedDate'] == null
          ? null
          : DateTime.parse(json['expectedDate'] as String),
    );

Map<String, dynamic> _$MilestoneOptionToJson(_MilestoneOption instance) =>
    <String, dynamic>{
      'code': instance.code,
      'group': instance.group,
      'title': instance.title,
      'icon': instance.icon,
      'recordedAt': instance.recordedAt?.toIso8601String(),
      'expectedDate': instance.expectedDate?.toIso8601String(),
    };
