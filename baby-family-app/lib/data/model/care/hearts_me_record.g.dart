// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hearts_me_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeartsMeRecord _$HeartsMeRecordFromJson(Map<String, dynamic> json) =>
    _HeartsMeRecord(
      today: (json['today'] as num?)?.toInt() ?? 0,
      week: (json['week'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      dailyCap: (json['dailyCap'] as num?)?.toInt(),
      history:
          (json['history'] as List<dynamic>?)
              ?.map(
                (e) => HeartHistoryRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <HeartHistoryRecord>[],
    );

Map<String, dynamic> _$HeartsMeRecordToJson(_HeartsMeRecord instance) =>
    <String, dynamic>{
      'today': instance.today,
      'week': instance.week,
      'total': instance.total,
      'dailyCap': instance.dailyCap,
      'history': instance.history.map((e) => e.toJson()).toList(),
    };
