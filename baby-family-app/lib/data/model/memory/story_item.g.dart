// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryItem _$StoryItemFromJson(Map<String, dynamic> json) => _StoryItem(
  id: json['id'] as String,
  childId: json['childId'] as String,
  asset: json['asset'] as String,
  memoryId: json['memoryId'] as String?,
  caption: json['caption'] as String?,
  authorId: json['authorId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  seen: json['seen'] as bool? ?? false,
);

Map<String, dynamic> _$StoryItemToJson(_StoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'asset': instance.asset,
      'memoryId': instance.memoryId,
      'caption': instance.caption,
      'authorId': instance.authorId,
      'createdAt': instance.createdAt.toIso8601String(),
      'seen': instance.seen,
    };
