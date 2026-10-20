// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'us_settings_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsSettingsRecord _$UsSettingsRecordFromJson(Map<String, dynamic> json) =>
    _UsSettingsRecord(
      usLockEnabled: json['usLockEnabled'] as bool?,
      moodShareDefault: json['moodShareDefault'] as String?,
      requestSoonBypassQuiet: json['requestSoonBypassQuiet'] as bool?,
      hideSensitivePreview: json['hideSensitivePreview'] as bool?,
    );

Map<String, dynamic> _$UsSettingsRecordToJson(_UsSettingsRecord instance) =>
    <String, dynamic>{
      'usLockEnabled': instance.usLockEnabled,
      'moodShareDefault': instance.moodShareDefault,
      'requestSoonBypassQuiet': instance.requestSoonBypassQuiet,
      'hideSensitivePreview': instance.hideSensitivePreview,
    };
