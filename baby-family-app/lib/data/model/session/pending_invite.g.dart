// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PendingInvite _$PendingInviteFromJson(Map<String, dynamic> json) =>
    _PendingInvite(
      code: json['code'] as String,
      kind: $enumDecode(_$InviteKindEnumMap, json['kind']),
      familyId: json['familyId'] as String?,
    );

Map<String, dynamic> _$PendingInviteToJson(_PendingInvite instance) =>
    <String, dynamic>{
      'code': instance.code,
      'kind': _$InviteKindEnumMap[instance.kind]!,
      'familyId': instance.familyId,
    };

const _$InviteKindEnumMap = {
  InviteKind.partner: 'partner',
  InviteKind.relative: 'relative',
};
