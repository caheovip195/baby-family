// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentRecord _$CommentRecordFromJson(Map<String, dynamic> json) =>
    _CommentRecord(
      id: json['id'] as String?,
      memoryId: json['memoryId'] as String?,
      authorUserId: json['authorUserId'] as String?,
      parentCommentId: json['parentCommentId'] as String?,
      body: json['body'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
    );

Map<String, dynamic> _$CommentRecordToJson(_CommentRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memoryId': instance.memoryId,
      'authorUserId': instance.authorUserId,
      'parentCommentId': instance.parentCommentId,
      'body': instance.body,
      'createdAt': instance.createdAt?.toIso8601String(),
      'editedAt': instance.editedAt?.toIso8601String(),
    };
