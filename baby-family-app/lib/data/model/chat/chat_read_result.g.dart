// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_read_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatReadResult _$ChatReadResultFromJson(Map<String, dynamic> json) =>
    _ChatReadResult(
      conversationId: json['conversationId'] as String? ?? '',
      readSeq: (json['readSeq'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ChatReadResultToJson(_ChatReadResult instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'readSeq': instance.readSeq,
    };
