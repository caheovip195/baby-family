// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyBadge _$FamilyBadgeFromJson(Map<String, dynamic> json) => _FamilyBadge(
  code: json['code'] as String,
  title: json['title'] as String,
  icon: json['icon'] as String?,
  achievedAt: json['achievedAt'] == null
      ? null
      : DateTime.parse(json['achievedAt'] as String),
  childId: json['childId'] as String?,
  hint: json['hint'] as String?,
  progress: (json['progress'] as num?)?.toInt(),
  target: (json['target'] as num?)?.toInt(),
);

Map<String, dynamic> _$FamilyBadgeToJson(_FamilyBadge instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'icon': instance.icon,
      'achievedAt': instance.achievedAt?.toIso8601String(),
      'childId': instance.childId,
      'hint': instance.hint,
      'progress': instance.progress,
      'target': instance.target,
    };
