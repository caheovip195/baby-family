// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_category_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionCategorySetting _$MissionCategorySettingFromJson(
  Map<String, dynamic> json,
) => _MissionCategorySetting(
  code: json['code'] as String,
  title: json['title'] as String,
  icon: json['icon'] as String?,
  enabled: json['enabled'] as bool? ?? true,
);

Map<String, dynamic> _$MissionCategorySettingToJson(
  _MissionCategorySetting instance,
) => <String, dynamic>{
  'code': instance.code,
  'title': instance.title,
  'icon': instance.icon,
  'enabled': instance.enabled,
};
