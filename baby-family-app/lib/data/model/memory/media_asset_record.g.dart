// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_asset_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaAssetRecord _$MediaAssetRecordFromJson(Map<String, dynamic> json) =>
    _MediaAssetRecord(
      assetId: json['assetId'] as String?,
      kind: json['kind'] as String?,
      status: json['status'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      durationMs: (json['durationMs'] as num?)?.toInt(),
      blurhash: json['blurhash'] as String?,
      urls:
          (json['urls'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      urlsExpireAt: json['urlsExpireAt'] == null
          ? null
          : DateTime.parse(json['urlsExpireAt'] as String),
      source: json['source'] == null
          ? null
          : MediaSourceRecord.fromJson(json['source'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MediaAssetRecordToJson(_MediaAssetRecord instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'kind': instance.kind,
      'status': instance.status,
      'width': instance.width,
      'height': instance.height,
      'durationMs': instance.durationMs,
      'blurhash': instance.blurhash,
      'urls': instance.urls,
      'urlsExpireAt': instance.urlsExpireAt?.toIso8601String(),
      'source': instance.source?.toJson(),
    };

_MediaSourceRecord _$MediaSourceRecordFromJson(Map<String, dynamic> json) =>
    _MediaSourceRecord(
      sha256: json['sha256'] as String?,
      key: json['key'] as String?,
      capturedAt: json['capturedAt'] == null
          ? null
          : DateTime.parse(json['capturedAt'] as String),
    );

Map<String, dynamic> _$MediaSourceRecordToJson(_MediaSourceRecord instance) =>
    <String, dynamic>{
      'sha256': instance.sha256,
      'key': instance.key,
      'capturedAt': instance.capturedAt?.toIso8601String(),
    };
