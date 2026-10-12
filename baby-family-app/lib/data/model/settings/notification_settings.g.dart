// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => _NotificationSettings(
  channels:
      (json['channels'] as List<dynamic>?)
          ?.map(
            (e) =>
                NotificationChannelSetting.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  quietHours: json['quietHours'] as bool? ?? true,
  quietFrom: json['quietFrom'] as String? ?? '22:00',
  quietTo: json['quietTo'] as String? ?? '06:30',
  urgentBypassQuiet: json['urgentBypassQuiet'] as bool? ?? false,
  hideOnLockScreen: json['hideOnLockScreen'] as bool? ?? true,
  relativesDigestTime: json['relativesDigestTime'] as String? ?? '19:00',
  mutedPeople: (json['mutedPeople'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$NotificationSettingsToJson(
  _NotificationSettings instance,
) => <String, dynamic>{
  'channels': instance.channels.map((e) => e.toJson()).toList(),
  'quietHours': instance.quietHours,
  'quietFrom': instance.quietFrom,
  'quietTo': instance.quietTo,
  'urgentBypassQuiet': instance.urgentBypassQuiet,
  'hideOnLockScreen': instance.hideOnLockScreen,
  'relativesDigestTime': instance.relativesDigestTime,
  'mutedPeople': instance.mutedPeople,
};
