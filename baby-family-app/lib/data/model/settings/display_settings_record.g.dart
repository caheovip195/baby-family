// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display_settings_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DisplaySettingsRecord _$DisplaySettingsRecordFromJson(
  Map<String, dynamic> json,
) => _DisplaySettingsRecord(
  theme: json['theme'] as String?,
  textScale: (json['textScale'] as num?)?.toDouble(),
  showLunar: json['showLunar'] as bool?,
);

Map<String, dynamic> _$DisplaySettingsRecordToJson(
  _DisplaySettingsRecord instance,
) => <String, dynamic>{
  'theme': instance.theme,
  'textScale': instance.textScale,
  'showLunar': instance.showLunar,
};
