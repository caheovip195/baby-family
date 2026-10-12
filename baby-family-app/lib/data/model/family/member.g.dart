// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  id: json['id'] as String,
  familyId: json['familyId'] as String,
  userId: json['userId'] as String?,
  role: $enumDecode(_$FamilyRoleEnumMap, json['role']),
  slot: $enumDecodeNullable(_$ParentSlotEnumMap, json['slot']),
  status:
      $enumDecodeNullable(_$MemberStatusEnumMap, json['status']) ??
      MemberStatus.active,
  displayName: json['displayName'] as String? ?? '',
  callName: json['callName'] as String? ?? '',
  avatarAsset: json['avatarAsset'] as String?,
  relation: $enumDecodeNullable(_$RelativeRelationEnumMap, json['relation']),
  grantedChildIds:
      (json['grantedChildIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  canComment: json['canComment'] as bool? ?? false,
  canPost: json['canPost'] as bool? ?? false,
  isAdmin: json['isAdmin'] as bool? ?? false,
  joinedAt: json['joinedAt'] == null
      ? null
      : DateTime.parse(json['joinedAt'] as String),
  childPermissions:
      (json['childPermissions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, $enumDecode(_$RelativePermissionEnumMap, e)),
      ) ??
      const {},
  allowDownload: json['allowDownload'] as bool? ?? false,
  notificationsMuted: json['notificationsMuted'] as bool? ?? false,
  paused: json['paused'] as bool? ?? false,
  lastActiveAt: json['lastActiveAt'] == null
      ? null
      : DateTime.parse(json['lastActiveAt'] as String),
  phoneMasked: json['phoneMasked'] as String?,
  postedCount: (json['postedCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'id': instance.id,
  'familyId': instance.familyId,
  'userId': instance.userId,
  'role': _$FamilyRoleEnumMap[instance.role]!,
  'slot': _$ParentSlotEnumMap[instance.slot],
  'status': _$MemberStatusEnumMap[instance.status]!,
  'displayName': instance.displayName,
  'callName': instance.callName,
  'avatarAsset': instance.avatarAsset,
  'relation': _$RelativeRelationEnumMap[instance.relation],
  'grantedChildIds': instance.grantedChildIds,
  'canComment': instance.canComment,
  'canPost': instance.canPost,
  'isAdmin': instance.isAdmin,
  'joinedAt': instance.joinedAt?.toIso8601String(),
  'childPermissions': instance.childPermissions.map(
    (k, e) => MapEntry(k, _$RelativePermissionEnumMap[e]!),
  ),
  'allowDownload': instance.allowDownload,
  'notificationsMuted': instance.notificationsMuted,
  'paused': instance.paused,
  'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
  'phoneMasked': instance.phoneMasked,
  'postedCount': instance.postedCount,
};

const _$FamilyRoleEnumMap = {
  FamilyRole.father: 'father',
  FamilyRole.mother: 'mother',
  FamilyRole.relative: 'relative',
};

const _$ParentSlotEnumMap = {ParentSlot.a: 'a', ParentSlot.b: 'b'};

const _$MemberStatusEnumMap = {
  MemberStatus.active: 'active',
  MemberStatus.pending: 'pending',
  MemberStatus.removed: 'removed',
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

const _$RelativePermissionEnumMap = {
  RelativePermission.hidden: 'hidden',
  RelativePermission.view: 'view',
  RelativePermission.comment: 'comment',
  RelativePermission.contribute: 'contribute',
};
