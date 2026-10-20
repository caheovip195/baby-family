// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appreciation_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppreciationRecord _$AppreciationRecordFromJson(Map<String, dynamic> json) =>
    _AppreciationRecord(
      id: json['id'] as String?,
      fromUserId: json['fromUserId'] as String?,
      toUserId: json['toUserId'] as String?,
      body: json['body'] as String?,
      sticker: json['sticker'] as String?,
      linkedType: json['linkedType'] as String?,
      linkedId: json['linkedId'] as String?,
      familyShareStatus: json['familyShareStatus'] as String?,
      reaction: json['reaction'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      isMine: json['isMine'] as bool? ?? false,
    );

Map<String, dynamic> _$AppreciationRecordToJson(_AppreciationRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'body': instance.body,
      'sticker': instance.sticker,
      'linkedType': instance.linkedType,
      'linkedId': instance.linkedId,
      'familyShareStatus': instance.familyShareStatus,
      'reaction': instance.reaction,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isMine': instance.isMine,
    };
