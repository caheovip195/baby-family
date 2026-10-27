// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OutboxEntry _$OutboxEntryFromJson(Map<String, dynamic> json) => _OutboxEntry(
  id: json['id'] as String,
  kind: json['kind'] as String,
  args: json['args'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  placeholder:
      json['placeholder'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  createdAt: DateTime.parse(json['createdAt'] as String),
  attempts: (json['attempts'] as num?)?.toInt() ?? 0,
  failed: json['failed'] as bool? ?? false,
);

Map<String, dynamic> _$OutboxEntryToJson(_OutboxEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'args': instance.args,
      'placeholder': instance.placeholder,
      'createdAt': instance.createdAt.toIso8601String(),
      'attempts': instance.attempts,
      'failed': instance.failed,
    };
