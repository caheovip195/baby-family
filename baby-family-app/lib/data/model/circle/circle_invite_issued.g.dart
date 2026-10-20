// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_invite_issued.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircleInviteIssued _$CircleInviteIssuedFromJson(Map<String, dynamic> json) =>
    _CircleInviteIssued(
      inviteId: json['inviteId'] as String?,
      code: json['code'] as String?,
      url: json['url'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$CircleInviteIssuedToJson(_CircleInviteIssued instance) =>
    <String, dynamic>{
      'inviteId': instance.inviteId,
      'code': instance.code,
      'url': instance.url,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
