// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlbumItem _$AlbumItemFromJson(Map<String, dynamic> json) => _AlbumItem(
  asset: json['asset'] as String,
  isVideo: json['isVideo'] as bool? ?? false,
  durationSec: (json['durationSec'] as num?)?.toInt(),
  memoryId: json['memoryId'] as String?,
);

Map<String, dynamic> _$AlbumItemToJson(_AlbumItem instance) =>
    <String, dynamic>{
      'asset': instance.asset,
      'isVideo': instance.isVideo,
      'durationSec': instance.durationSec,
      'memoryId': instance.memoryId,
    };
