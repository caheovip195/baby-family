// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessagePage _$ChatMessagePageFromJson(Map<String, dynamic> json) =>
    _ChatMessagePage(
      items: json['items'] == null
          ? const <ChatMessage>[]
          : chatMessageList(json['items']),
      hasMore: json['hasMore'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatMessagePageToJson(_ChatMessagePage instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'hasMore': instance.hasMore,
    };
