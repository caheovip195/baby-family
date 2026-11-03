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
      audioAssetId: json['audioAssetId'] as String?,
      audioUrl: json['audioUrl'] as String?,
      audioDurationSec: (json['audioDurationSec'] as num?)?.toInt(),
      assets: json['assets'] == null
          ? const <PerspectiveAssetRecord>[]
          : _perspectiveAssets(json['assets']),
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
      'audioAssetId': instance.audioAssetId,
      'audioUrl': instance.audioUrl,
      'audioDurationSec': instance.audioDurationSec,
      'assets': instance.assets.map((e) => e.toJson()).toList(),
      'hiddenFromCircle': instance.hiddenFromCircle,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_PerspectiveAssetRecord _$PerspectiveAssetRecordFromJson(
  Map<String, dynamic> json,
) => _PerspectiveAssetRecord(
  assetId: json['assetId'] as String,
  kind: json['kind'] as String? ?? 'IMAGE',
  url: json['url'] as String?,
  videoUrl: json['videoUrl'] as String?,
);

Map<String, dynamic> _$PerspectiveAssetRecordToJson(
  _PerspectiveAssetRecord instance,
) => <String, dynamic>{
  'assetId': instance.assetId,
  'kind': instance.kind,
  'url': instance.url,
  'videoUrl': instance.videoUrl,
};
