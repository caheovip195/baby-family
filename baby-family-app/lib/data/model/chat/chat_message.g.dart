// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String? ?? '',
  seq: (json['seq'] as num?)?.toInt() ?? 0,
  senderUserId: json['senderUserId'] as String? ?? '',
  body: json['body'] as String? ?? '',
  isMine: json['isMine'] as bool? ?? false,
  clientKey: json['clientKey'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  localState: json['localState'] as String?,
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'seq': instance.seq,
      'senderUserId': instance.senderUserId,
      'body': instance.body,
      'isMine': instance.isMine,
      'clientKey': instance.clientKey,
      'createdAt': instance.createdAt?.toIso8601String(),
      'localState': instance.localState,
    };
