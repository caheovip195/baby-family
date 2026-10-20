// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JourneyRecord _$JourneyRecordFromJson(Map<String, dynamic> json) =>
    _JourneyRecord(
      pregnancyId: json['pregnancyId'] as String?,
      currentWeek: (json['currentWeek'] as num?)?.toInt(),
      currentDay: (json['currentDay'] as num?)?.toInt(),
      daysLeft: (json['daysLeft'] as num?)?.toInt(),
      week: json['week'] == null
          ? null
          : JourneyWeekRecord.fromJson(json['week'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JourneyRecordToJson(_JourneyRecord instance) =>
    <String, dynamic>{
      'pregnancyId': instance.pregnancyId,
      'currentWeek': instance.currentWeek,
      'currentDay': instance.currentDay,
      'daysLeft': instance.daysLeft,
      'week': instance.week?.toJson(),
    };
