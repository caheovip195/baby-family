// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_series_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionSeriesRecord _$MissionSeriesRecordFromJson(Map<String, dynamic> json) =>
    _MissionSeriesRecord(
      id: json['id'] as String?,
      title: json['title'] as String?,
      ownerKind: json['ownerKind'] as String?,
      mine: json['mine'] as bool? ?? false,
      scheduledTime: json['scheduledTime'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      days:
          (json['days'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      pausedRanges:
          (json['pausedRanges'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const <Map<String, dynamic>>[],
      status: json['status'] as String?,
    );

Map<String, dynamic> _$MissionSeriesRecordToJson(
  _MissionSeriesRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'ownerKind': instance.ownerKind,
  'mine': instance.mine,
  'scheduledTime': instance.scheduledTime,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'days': instance.days,
  'pausedRanges': instance.pausedRanges,
  'status': instance.status,
};
