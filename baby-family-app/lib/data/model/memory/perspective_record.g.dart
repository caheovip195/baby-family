// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perspective_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PerspectiveRecord _$PerspectiveRecordFromJson(Map<String, dynamic> json) =>
    _PerspectiveRecord(
      id: json['id'] as String?,
      memoryId: json['memoryId'] as String?,
      authorUserId: json['authorUserId'] as String?,
      body: json['body'] as String?,
      hiddenFromCircle: json['hiddenFromCircle'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PerspectiveRecordToJson(_PerspectiveRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memoryId': instance.memoryId,
      'authorUserId': instance.authorUserId,
      'body': instance.body,
      'hiddenFromCircle': instance.hiddenFromCircle,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
