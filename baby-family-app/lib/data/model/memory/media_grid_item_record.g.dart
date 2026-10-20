// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_grid_item_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaGridItemRecord _$MediaGridItemRecordFromJson(Map<String, dynamic> json) =>
    _MediaGridItemRecord(
      assetId: json['assetId'] as String?,
      memoryId: json['memoryId'] as String?,
      kind: json['kind'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      durationMs: (json['durationMs'] as num?)?.toInt(),
      blurhash: json['blurhash'] as String?,
      occurredAt: json['occurredAt'] == null
          ? null
          : DateTime.parse(json['occurredAt'] as String),
      urls:
          (json['urls'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      urlsExpireAt: json['urlsExpireAt'] == null
          ? null
          : DateTime.parse(json['urlsExpireAt'] as String),
    );

Map<String, dynamic> _$MediaGridItemRecordToJson(
  _MediaGridItemRecord instance,
) => <String, dynamic>{
  'assetId': instance.assetId,
  'memoryId': instance.memoryId,
  'kind': instance.kind,
  'width': instance.width,
  'height': instance.height,
  'durationMs': instance.durationMs,
  'blurhash': instance.blurhash,
  'occurredAt': instance.occurredAt?.toIso8601String(),
  'urls': instance.urls,
  'urlsExpireAt': instance.urlsExpireAt?.toIso8601String(),
};
