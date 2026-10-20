// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_settings_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiSettingsRecord _$AiSettingsRecordFromJson(Map<String, dynamic> json) =>
    _AiSettingsRecord(
      aiEnabled: json['aiEnabled'] as bool?,
      features:
          (json['features'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const <String, bool>{},
    );

Map<String, dynamic> _$AiSettingsRecordToJson(_AiSettingsRecord instance) =>
    <String, dynamic>{
      'aiEnabled': instance.aiEnabled,
      'features': instance.features,
    };
