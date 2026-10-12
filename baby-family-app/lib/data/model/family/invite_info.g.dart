// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InviteInfo _$InviteInfoFromJson(Map<String, dynamic> json) => _InviteInfo(
  id: json['id'] as String,
  code: json['code'] as String,
  kind: $enumDecode(_$InviteKindEnumMap, json['kind']),
  familyId: json['familyId'] as String,
  familyName: json['familyName'] as String?,
  inviterName: json['inviterName'] as String?,
  inviterCallName: json['inviterCallName'] as String?,
  inviterAvatarAsset: json['inviterAvatarAsset'] as String?,
  memberId: json['memberId'] as String?,
  message: json['message'] as String?,
  role:
      $enumDecodeNullable(_$FamilyRoleEnumMap, json['role']) ??
      FamilyRole.relative,
  relation: $enumDecodeNullable(_$RelativeRelationEnumMap, json['relation']),
  callName: json['callName'] as String?,
  grantedChildIds:
      (json['grantedChildIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  canComment: json['canComment'] as bool? ?? false,
  canPost: json['canPost'] as bool? ?? false,
  link: json['link'] as String?,
  sentAt: json['sentAt'] == null
      ? null
      : DateTime.parse(json['sentAt'] as String),
  openedAt: json['openedAt'] == null
      ? null
      : DateTime.parse(json['openedAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  status: json['status'] as String? ?? 'open',
);

Map<String, dynamic> _$InviteInfoToJson(_InviteInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'kind': _$InviteKindEnumMap[instance.kind]!,
      'familyId': instance.familyId,
      'familyName': instance.familyName,
      'inviterName': instance.inviterName,
      'inviterCallName': instance.inviterCallName,
      'inviterAvatarAsset': instance.inviterAvatarAsset,
      'memberId': instance.memberId,
      'message': instance.message,
      'role': _$FamilyRoleEnumMap[instance.role]!,
      'relation': _$RelativeRelationEnumMap[instance.relation],
      'callName': instance.callName,
      'grantedChildIds': instance.grantedChildIds,
      'canComment': instance.canComment,
      'canPost': instance.canPost,
      'link': instance.link,
      'sentAt': instance.sentAt?.toIso8601String(),
      'openedAt': instance.openedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'status': instance.status,
    };

const _$InviteKindEnumMap = {
  InviteKind.partner: 'partner',
  InviteKind.relative: 'relative',
};

const _$FamilyRoleEnumMap = {
  FamilyRole.father: 'father',
  FamilyRole.mother: 'mother',
  FamilyRole.relative: 'relative',
};

const _$RelativeRelationEnumMap = {
  RelativeRelation.grandmaPaternal: 'grandmaPaternal',
  RelativeRelation.grandpaPaternal: 'grandpaPaternal',
  RelativeRelation.grandmaMaternal: 'grandmaMaternal',
  RelativeRelation.grandpaMaternal: 'grandpaMaternal',
  RelativeRelation.auntUncle: 'auntUncle',
  RelativeRelation.nanny: 'nanny',
  RelativeRelation.other: 'other',
};
