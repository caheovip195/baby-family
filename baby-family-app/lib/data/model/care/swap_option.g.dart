// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swap_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SwapOption _$SwapOptionFromJson(Map<String, dynamic> json) => _SwapOption(
  missionId: json['missionId'] as String,
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => MissionTemplate.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  swapsLeft: (json['swapsLeft'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SwapOptionToJson(_SwapOption instance) =>
    <String, dynamic>{
      'missionId': instance.missionId,
      'options': instance.options.map((e) => e.toJson()).toList(),
      'swapsLeft': instance.swapsLeft,
    };
