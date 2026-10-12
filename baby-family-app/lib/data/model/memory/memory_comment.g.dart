// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoryComment _$MemoryCommentFromJson(Map<String, dynamic> json) =>
    _MemoryComment(
      id: json['id'] as String,
      memoryId: json['memoryId'] as String,
      authorId: json['authorId'] as String?,
      authorName: json['authorName'] as String? ?? '',
      authorRole: $enumDecodeNullable(_$FamilyRoleEnumMap, json['authorRole']),
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      pendingApproval: json['pendingApproval'] as bool? ?? false,
      parentId: json['parentId'] as String?,
    );

Map<String, dynamic> _$MemoryCommentToJson(_MemoryComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memoryId': instance.memoryId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorRole': _$FamilyRoleEnumMap[instance.authorRole],
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
      'pendingApproval': instance.pendingApproval,
      'parentId': instance.parentId,
    };

const _$FamilyRoleEnumMap = {
  FamilyRole.father: 'father',
  FamilyRole.mother: 'mother',
  FamilyRole.relative: 'relative',
};
