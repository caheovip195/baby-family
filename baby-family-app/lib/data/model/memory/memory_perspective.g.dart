// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_perspective.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoryPerspective _$MemoryPerspectiveFromJson(Map<String, dynamic> json) =>
    _MemoryPerspective(
      id: json['id'] as String,
      memoryId: json['memoryId'] as String,
      authorId: json['authorId'] as String,
      body: json['body'] as String? ?? '',
      mediaAssets:
          (json['mediaAssets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      hiddenFromRelatives: json['hiddenFromRelatives'] as bool? ?? false,
    );

Map<String, dynamic> _$MemoryPerspectiveToJson(_MemoryPerspective instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memoryId': instance.memoryId,
      'authorId': instance.authorId,
      'body': instance.body,
      'mediaAssets': instance.mediaAssets,
      'createdAt': instance.createdAt.toIso8601String(),
      'hiddenFromRelatives': instance.hiddenFromRelatives,
    };
