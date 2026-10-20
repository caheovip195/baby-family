// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockedUserRecord _$BlockedUserRecordFromJson(Map<String, dynamic> json) =>
    _BlockedUserRecord(
      userId: json['userId'] as String?,
      displayName: json['displayName'] as String?,
      blockedAt: json['blockedAt'] == null
          ? null
          : DateTime.parse(json['blockedAt'] as String),
    );

Map<String, dynamic> _$BlockedUserRecordToJson(_BlockedUserRecord instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'blockedAt': instance.blockedAt?.toIso8601String(),
    };
