// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_resolution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InviteResolution _$InviteResolutionFromJson(Map<String, dynamic> json) =>
    _InviteResolution(
      inviteId: json['inviteId'] as String?,
      type: json['type'] as String?,
      state: json['state'] as String?,
      familyName: json['familyName'] as String?,
      inviterCallName: json['inviterCallName'] as String?,
      inviterKind: json['inviterKind'] as String?,
      proposedKind: json['proposedKind'] as String?,
      message: json['message'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      relation: json['relation'] as String?,
      displayName: json['displayName'] as String?,
      children:
          (json['children'] as List<dynamic>?)
              ?.map(
                (e) => CircleSubjectRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <CircleSubjectRecord>[],
    );

Map<String, dynamic> _$InviteResolutionToJson(_InviteResolution instance) =>
    <String, dynamic>{
      'inviteId': instance.inviteId,
      'type': instance.type,
      'state': instance.state,
      'familyName': instance.familyName,
      'inviterCallName': instance.inviterCallName,
      'inviterKind': instance.inviterKind,
      'proposedKind': instance.proposedKind,
      'message': instance.message,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'relation': instance.relation,
      'displayName': instance.displayName,
      'children': instance.children.map((e) => e.toJson()).toList(),
    };
