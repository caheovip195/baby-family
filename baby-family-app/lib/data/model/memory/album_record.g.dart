// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlbumRecord _$AlbumRecordFromJson(Map<String, dynamic> json) => _AlbumRecord(
  id: json['id'] as String?,
  name: json['name'] as String?,
  ownerUserId: json['ownerUserId'] as String?,
  isSensitive: json['isSensitive'] as bool? ?? false,
  coverMemoryId: json['coverMemoryId'] as String?,
  cover: json['cover'] == null
      ? null
      : MemoryRecord.fromJson(json['cover'] as Map<String, dynamic>),
  memoryCount: (json['memoryCount'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AlbumRecordToJson(_AlbumRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ownerUserId': instance.ownerUserId,
      'isSensitive': instance.isSensitive,
      'coverMemoryId': instance.coverMemoryId,
      'cover': instance.cover?.toJson(),
      'memoryCount': instance.memoryCount,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
