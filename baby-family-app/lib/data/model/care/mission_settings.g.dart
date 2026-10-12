// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionSettings _$MissionSettingsFromJson(Map<String, dynamic> json) =>
    _MissionSettings(
      level:
          $enumDecodeNullable(_$MissionLoadLevelEnumMap, json['level']) ??
          MissionLoadLevel.medium,
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (e) =>
                    MissionCategorySetting.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      boardTime: json['boardTime'] as String? ?? '07:00',
      askAtNight: json['askAtNight'] as bool? ?? true,
      defaultReminder:
          $enumDecodeNullable(
            _$MissionReminderEnumMap,
            json['defaultReminder'],
          ) ??
          MissionReminder.before15,
    );

Map<String, dynamic> _$MissionSettingsToJson(_MissionSettings instance) =>
    <String, dynamic>{
      'level': _$MissionLoadLevelEnumMap[instance.level]!,
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'boardTime': instance.boardTime,
      'askAtNight': instance.askAtNight,
      'defaultReminder': _$MissionReminderEnumMap[instance.defaultReminder]!,
    };

const _$MissionLoadLevelEnumMap = {
  MissionLoadLevel.light: 'light',
  MissionLoadLevel.medium: 'medium',
  MissionLoadLevel.heavy: 'heavy',
};

const _$MissionReminderEnumMap = {
  MissionReminder.none: 'none',
  MissionReminder.atTime: 'atTime',
  MissionReminder.before15: 'before15',
  MissionReminder.before30: 'before30',
  MissionReminder.before60: 'before60',
};
