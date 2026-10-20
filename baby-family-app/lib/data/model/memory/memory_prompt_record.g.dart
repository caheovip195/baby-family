// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_prompt_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoryPromptRecord _$MemoryPromptRecordFromJson(Map<String, dynamic> json) =>
    _MemoryPromptRecord(
      code: json['code'] as String?,
      targetKind: json['targetKind'] as String?,
      textI18n:
          json['textI18n'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      childId: json['childId'] as String?,
    );

Map<String, dynamic> _$MemoryPromptRecordToJson(_MemoryPromptRecord instance) =>
    <String, dynamic>{
      'code': instance.code,
      'targetKind': instance.targetKind,
      'textI18n': instance.textI18n,
      'childId': instance.childId,
    };
