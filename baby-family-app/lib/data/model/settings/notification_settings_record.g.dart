// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettingsRecord _$NotificationSettingsRecordFromJson(
  Map<String, dynamic> json,
) => _NotificationSettingsRecord(
  quietStart: json['quietStart'] as String?,
  quietEnd: json['quietEnd'] as String?,
  hideSensitivePreview: json['hideSensitivePreview'] as bool?,
  categories:
      (json['categories'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ) ??
      const <String, bool>{},
  circleDigestMode: json['circleDigestMode'] as String?,
  circleDigestTime: json['circleDigestTime'] as String?,
);

Map<String, dynamic> _$NotificationSettingsRecordToJson(
  _NotificationSettingsRecord instance,
) => <String, dynamic>{
  'quietStart': instance.quietStart,
  'quietEnd': instance.quietEnd,
  'hideSensitivePreview': instance.hideSensitivePreview,
  'categories': instance.categories,
  'circleDigestMode': instance.circleDigestMode,
  'circleDigestTime': instance.circleDigestTime,
};
