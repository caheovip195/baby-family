// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_prompt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoryPrompt _$MemoryPromptFromJson(Map<String, dynamic> json) =>
    _MemoryPrompt(
      id: json['id'] as String,
      childId: json['childId'] as String?,
      kind:
          $enumDecodeNullable(_$MemoryKindEnumMap, json['kind']) ??
          MemoryKind.quote,
      text: json['text'] as String,
    );

Map<String, dynamic> _$MemoryPromptToJson(_MemoryPrompt instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'kind': _$MemoryKindEnumMap[instance.kind]!,
      'text': instance.text,
    };

const _$MemoryKindEnumMap = {
  MemoryKind.photo: 'photo',
  MemoryKind.diary: 'diary',
  MemoryKind.voice: 'voice',
  MemoryKind.quote: 'quote',
  MemoryKind.monthlyPhoto: 'monthlyPhoto',
  MemoryKind.keepsake: 'keepsake',
  MemoryKind.letter: 'letter',
  MemoryKind.ultrasound: 'ultrasound',
  MemoryKind.bump: 'bump',
  MemoryKind.milestone: 'milestone',
  MemoryKind.fromMission: 'fromMission',
};
