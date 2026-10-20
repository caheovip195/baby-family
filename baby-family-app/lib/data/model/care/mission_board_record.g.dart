// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_board_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionBoardRecord _$MissionBoardRecordFromJson(Map<String, dynamic> json) =>
    _MissionBoardRecord(
      date: json['date'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => MissionRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MissionRecord>[],
      myHeartsToday: (json['myHeartsToday'] as num?)?.toInt(),
      swapsLeft: (json['swapsLeft'] as num?)?.toInt(),
      openRequestCount: (json['openRequestCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MissionBoardRecordToJson(_MissionBoardRecord instance) =>
    <String, dynamic>{
      'date': instance.date,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'myHeartsToday': instance.myHeartsToday,
      'swapsLeft': instance.swapsLeft,
      'openRequestCount': instance.openRequestCount,
    };
