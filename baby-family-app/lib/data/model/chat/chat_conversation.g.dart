// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatConversation _$ChatConversationFromJson(Map<String, dynamic> json) =>
    _ChatConversation(
      id: json['id'] as String,
      familyId: json['familyId'] as String? ?? '',
      kind: json['kind'] as String? ?? '',
      lastSeq: (json['lastSeq'] as num?)?.toInt() ?? 0,
      readSeq: (json['readSeq'] as num?)?.toInt() ?? 0,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      lastMessage: _chatLastMessage(json['lastMessage']),
      members: json['members'] == null
          ? const <ChatMember>[]
          : _chatMembers(json['members']),
    );

Map<String, dynamic> _$ChatConversationToJson(_ChatConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'kind': instance.kind,
      'lastSeq': instance.lastSeq,
      'readSeq': instance.readSeq,
      'unreadCount': instance.unreadCount,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'lastMessage': instance.lastMessage?.toJson(),
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
