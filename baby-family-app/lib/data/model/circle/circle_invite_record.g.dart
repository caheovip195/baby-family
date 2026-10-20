// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_invite_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircleInviteRecord _$CircleInviteRecordFromJson(Map<String, dynamic> json) =>
    _CircleInviteRecord(
      inviteId: json['inviteId'] as String?,
      status: json['status'] as String?,
      relation: json['relation'] as String?,
      displayName: json['displayName'] as String?,
      grants:
          (json['grants'] as List<dynamic>?)
              ?.map(
                (e) => CircleGrantRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <CircleGrantRecord>[],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$CircleInviteRecordToJson(_CircleInviteRecord instance) =>
    <String, dynamic>{
      'inviteId': instance.inviteId,
      'status': instance.status,
      'relation': instance.relation,
      'displayName': instance.displayName,
      'grants': instance.grants.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
