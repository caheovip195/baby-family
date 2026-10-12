// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'on_this_day_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnThisDayGroup _$OnThisDayGroupFromJson(Map<String, dynamic> json) =>
    _OnThisDayGroup(
      yearsAgo: (json['yearsAgo'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      childId: json['childId'] as String?,
      memories:
          (json['memories'] as List<dynamic>?)
              ?.map((e) => Memory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OnThisDayGroupToJson(_OnThisDayGroup instance) =>
    <String, dynamic>{
      'yearsAgo': instance.yearsAgo,
      'date': instance.date.toIso8601String(),
      'childId': instance.childId,
      'memories': instance.memories.map((e) => e.toJson()).toList(),
    };
