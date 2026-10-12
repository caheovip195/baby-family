// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_memory_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChildMemoryStats _$ChildMemoryStatsFromJson(Map<String, dynamic> json) =>
    _ChildMemoryStats(
      childId: json['childId'] as String,
      memories: (json['memories'] as num?)?.toInt() ?? 0,
      firsts: (json['firsts'] as num?)?.toInt() ?? 0,
      voices: (json['voices'] as num?)?.toInt() ?? 0,
      quotes: (json['quotes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ChildMemoryStatsToJson(_ChildMemoryStats instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'memories': instance.memories,
      'firsts': instance.firsts,
      'voices': instance.voices,
      'quotes': instance.quotes,
    };
