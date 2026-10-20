// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_preferences_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionPreferencesRecord _$MissionPreferencesRecordFromJson(
  Map<String, dynamic> json,
) => _MissionPreferencesRecord(
  disabledCategories:
      (json['disabledCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  boardPushTime: json['boardPushTime'] as String?,
  eveningCarryOver: json['eveningCarryOver'] as bool? ?? true,
  defaultReminderMin: (json['defaultReminderMin'] as num?)?.toInt(),
);

Map<String, dynamic> _$MissionPreferencesRecordToJson(
  _MissionPreferencesRecord instance,
) => <String, dynamic>{
  'disabledCategories': instance.disabledCategories,
  'boardPushTime': instance.boardPushTime,
  'eveningCarryOver': instance.eveningCarryOver,
  'defaultReminderMin': instance.defaultReminderMin,
};
