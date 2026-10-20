// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_swap_options_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionSwapOptionsRecord _$MissionSwapOptionsRecordFromJson(
  Map<String, dynamic> json,
) => _MissionSwapOptionsRecord(
  options:
      (json['options'] as List<dynamic>?)
          ?.map(
            (e) => MissionTemplateRecord.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <MissionTemplateRecord>[],
  optionsToken: json['optionsToken'] as String?,
  swapsLeft: (json['swapsLeft'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MissionSwapOptionsRecordToJson(
  _MissionSwapOptionsRecord instance,
) => <String, dynamic>{
  'options': instance.options.map((e) => e.toJson()).toList(),
  'optionsToken': instance.optionsToken,
  'swapsLeft': instance.swapsLeft,
};
