// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_history_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionHistoryDay _$MissionHistoryDayFromJson(Map<String, dynamic> json) =>
    _MissionHistoryDay(
      date: DateTime.parse(json['date'] as String),
      entries:
          (json['entries'] as List<dynamic>?)
              ?.map(
                (e) => MissionHistoryEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MissionHistoryDayToJson(_MissionHistoryDay instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'entries': instance.entries.map((e) => e.toJson()).toList(),
    };
