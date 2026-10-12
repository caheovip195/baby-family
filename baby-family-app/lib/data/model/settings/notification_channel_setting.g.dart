// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_channel_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationChannelSetting _$NotificationChannelSettingFromJson(
  Map<String, dynamic> json,
) => _NotificationChannelSetting(
  code: json['code'] as String,
  title: json['title'] as String,
  hint: json['hint'] as String?,
  icon: json['icon'] as String?,
  enabled: json['enabled'] as bool? ?? true,
);

Map<String, dynamic> _$NotificationChannelSettingToJson(
  _NotificationChannelSetting instance,
) => <String, dynamic>{
  'code': instance.code,
  'title': instance.title,
  'hint': instance.hint,
  'icon': instance.icon,
  'enabled': instance.enabled,
};
