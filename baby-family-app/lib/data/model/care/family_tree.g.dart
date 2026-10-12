// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyTree _$FamilyTreeFromJson(Map<String, dynamic> json) => _FamilyTree(
  level: (json['level'] as num?)?.toInt() ?? 1,
  name: json['name'] as String? ?? '',
  nextName: json['nextName'] as String?,
  nextReward: json['nextReward'] as String?,
  progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
  todayLeaves: (json['todayLeaves'] as num?)?.toInt() ?? 0,
  todayTotal: (json['todayTotal'] as num?)?.toInt() ?? 0,
  bloomed: json['bloomed'] as bool? ?? false,
  weekCareMoments: (json['weekCareMoments'] as num?)?.toInt() ?? 0,
  weekTogether: (json['weekTogether'] as num?)?.toInt() ?? 0,
  weekBloomDays: (json['weekBloomDays'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FamilyTreeToJson(_FamilyTree instance) =>
    <String, dynamic>{
      'level': instance.level,
      'name': instance.name,
      'nextName': instance.nextName,
      'nextReward': instance.nextReward,
      'progressPercent': instance.progressPercent,
      'todayLeaves': instance.todayLeaves,
      'todayTotal': instance.todayTotal,
      'bloomed': instance.bloomed,
      'weekCareMoments': instance.weekCareMoments,
      'weekTogether': instance.weekTogether,
      'weekBloomDays': instance.weekBloomDays,
    };
