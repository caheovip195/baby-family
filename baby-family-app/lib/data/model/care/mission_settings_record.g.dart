// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_settings_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionSettingsRecord _$MissionSettingsRecordFromJson(
  Map<String, dynamic> json,
) => _MissionSettingsRecord(
  boardLevel: json['boardLevel'] as String?,
  preferences: json['preferences'] == null
      ? null
      : MissionPreferencesRecord.fromJson(
          json['preferences'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$MissionSettingsRecordToJson(
  _MissionSettingsRecord instance,
) => <String, dynamic>{
  'boardLevel': instance.boardLevel,
  'preferences': instance.preferences?.toJson(),
};
