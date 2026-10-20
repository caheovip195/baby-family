// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_invite_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartnerInviteStatus _$PartnerInviteStatusFromJson(Map<String, dynamic> json) =>
    _PartnerInviteStatus(
      inviteId: json['inviteId'] as String?,
      status: json['status'] as String?,
      kind: json['kind'] as String?,
      requireFinalApproval: json['requireFinalApproval'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      acceptedCallName: json['acceptedCallName'] as String?,
    );

Map<String, dynamic> _$PartnerInviteStatusToJson(
  _PartnerInviteStatus instance,
) => <String, dynamic>{
  'inviteId': instance.inviteId,
  'status': instance.status,
  'kind': instance.kind,
  'requireFinalApproval': instance.requireFinalApproval,
  'createdAt': instance.createdAt?.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'acceptedCallName': instance.acceptedCallName,
};
