// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMember _$ChatMemberFromJson(Map<String, dynamic> json) => _ChatMember(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String? ?? '',
  role: json['role'] as String? ?? 'CIRCLE',
  lastReadSeq: (json['lastReadSeq'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ChatMemberToJson(_ChatMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'role': instance.role,
      'lastReadSeq': instance.lastReadSeq,
    };
