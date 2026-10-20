// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_series_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionSeriesList _$MissionSeriesListFromJson(Map<String, dynamic> json) =>
    _MissionSeriesList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => MissionSeriesRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <MissionSeriesRecord>[],
    );

Map<String, dynamic> _$MissionSeriesListToJson(_MissionSeriesList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
