// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'on_this_day_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnThisDayRecord _$OnThisDayRecordFromJson(Map<String, dynamic> json) =>
    _OnThisDayRecord(
      date: json['date'] as String?,
      groups:
          (json['groups'] as List<dynamic>?)
              ?.map(
                (e) => OnThisDayGroupRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <OnThisDayGroupRecord>[],
    );

Map<String, dynamic> _$OnThisDayRecordToJson(_OnThisDayRecord instance) =>
    <String, dynamic>{
      'date': instance.date,
      'groups': instance.groups.map((e) => e.toJson()).toList(),
    };

_OnThisDayGroupRecord _$OnThisDayGroupRecordFromJson(
  Map<String, dynamic> json,
) => _OnThisDayGroupRecord(
  yearsAgo: (json['yearsAgo'] as num?)?.toInt() ?? 0,
  date: json['date'] as String?,
  memories:
      (json['memories'] as List<dynamic>?)
          ?.map((e) => MemoryRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MemoryRecord>[],
);

Map<String, dynamic> _$OnThisDayGroupRecordToJson(
  _OnThisDayGroupRecord instance,
) => <String, dynamic>{
  'yearsAgo': instance.yearsAgo,
  'date': instance.date,
  'memories': instance.memories.map((e) => e.toJson()).toList(),
};
