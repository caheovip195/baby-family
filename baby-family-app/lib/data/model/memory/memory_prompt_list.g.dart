// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_prompt_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoryPromptList _$MemoryPromptListFromJson(Map<String, dynamic> json) =>
    _MemoryPromptList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => MemoryPromptRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <MemoryPromptRecord>[],
    );

Map<String, dynamic> _$MemoryPromptListToJson(_MemoryPromptList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
