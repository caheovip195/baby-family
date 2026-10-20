// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_url_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DownloadUrlRecord _$DownloadUrlRecordFromJson(Map<String, dynamic> json) =>
    _DownloadUrlRecord(
      assetId: json['assetId'] as String?,
      kind: json['kind'] as String?,
      url: json['url'] as String?,
      fileName: json['fileName'] as String?,
    );

Map<String, dynamic> _$DownloadUrlRecordToJson(_DownloadUrlRecord instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'kind': instance.kind,
      'url': instance.url,
      'fileName': instance.fileName,
    };
