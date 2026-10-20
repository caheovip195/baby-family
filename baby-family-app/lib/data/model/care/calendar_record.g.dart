// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarRecord _$CalendarRecordFromJson(
  Map<String, dynamic> json,
) => _CalendarRecord(
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => CalendarEventRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CalendarEventRecord>[],
  missions:
      (json['missions'] as List<dynamic>?)
          ?.map((e) => MissionRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MissionRecord>[],
  specialDays:
      (json['specialDays'] as List<dynamic>?)
          ?.map(
            (e) => CalendarSpecialDayRecord.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <CalendarSpecialDayRecord>[],
);

Map<String, dynamic> _$CalendarRecordToJson(_CalendarRecord instance) =>
    <String, dynamic>{
      'events': instance.events.map((e) => e.toJson()).toList(),
      'missions': instance.missions.map((e) => e.toJson()).toList(),
      'specialDays': instance.specialDays.map((e) => e.toJson()).toList(),
    };
