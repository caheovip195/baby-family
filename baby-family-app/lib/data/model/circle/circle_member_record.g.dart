// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_member_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircleMemberRecord _$CircleMemberRecordFromJson(Map<String, dynamic> json) =>
    _CircleMemberRecord(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      displayName: json['displayName'] as String?,
      relation: json['relation'] as String?,
      status: json['status'] as String?,
      allowDownload: json['allowDownload'] as bool? ?? false,
      grants:
          (json['grants'] as List<dynamic>?)
              ?.map(
                (e) => CircleGrantRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <CircleGrantRecord>[],
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$CircleMemberRecordToJson(_CircleMemberRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'displayName': instance.displayName,
      'relation': instance.relation,
      'status': instance.status,
      'allowDownload': instance.allowDownload,
      'grants': instance.grants.map((e) => e.toJson()).toList(),
      'joinedAt': instance.joinedAt?.toIso8601String(),
    };
