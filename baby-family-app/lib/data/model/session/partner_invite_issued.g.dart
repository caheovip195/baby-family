// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_invite_issued.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartnerInviteIssued _$PartnerInviteIssuedFromJson(Map<String, dynamic> json) =>
    _PartnerInviteIssued(
      inviteId: json['inviteId'] as String?,
      url: json['url'] as String?,
      code: json['code'] as String?,
      qrPayload: json['qrPayload'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$PartnerInviteIssuedToJson(
  _PartnerInviteIssued instance,
) => <String, dynamic>{
  'inviteId': instance.inviteId,
  'url': instance.url,
  'code': instance.code,
  'qrPayload': instance.qrPayload,
  'expiresAt': instance.expiresAt?.toIso8601String(),
};
