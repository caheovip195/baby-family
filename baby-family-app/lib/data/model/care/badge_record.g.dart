// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BadgeRecord _$BadgeRecordFromJson(Map<String, dynamic> json) => _BadgeRecord(
  code: json['code'] as String?,
  title: json['title'] as String?,
  titleI18n:
      (json['titleI18n'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  description: json['description'] as String?,
  descI18n:
      (json['descI18n'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  icon: json['icon'] as String?,
  earned: json['earned'] as bool? ?? false,
  achievedAt: json['achievedAt'] == null
      ? null
      : DateTime.parse(json['achievedAt'] as String),
  progress: json['progress'] == null
      ? null
      : BadgeProgressRecord.fromJson(json['progress'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BadgeRecordToJson(_BadgeRecord instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'titleI18n': instance.titleI18n,
      'description': instance.description,
      'descI18n': instance.descI18n,
      'icon': instance.icon,
      'earned': instance.earned,
      'achievedAt': instance.achievedAt?.toIso8601String(),
      'progress': instance.progress?.toJson(),
    };
