// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_week_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JourneyWeekRecord _$JourneyWeekRecordFromJson(Map<String, dynamic> json) =>
    _JourneyWeekRecord(
      number: (json['number'] as num?)?.toInt(),
      size: json['size'] == null
          ? null
          : JourneySizeRecord.fromJson(json['size'] as Map<String, dynamic>),
      tip: json['tip'] as String?,
    );

Map<String, dynamic> _$JourneyWeekRecordToJson(_JourneyWeekRecord instance) =>
    <String, dynamic>{
      'number': instance.number,
      'size': instance.size?.toJson(),
      'tip': instance.tip,
    };
