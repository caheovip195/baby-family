// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_url_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DownloadUrlList _$DownloadUrlListFromJson(Map<String, dynamic> json) =>
    _DownloadUrlList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => DownloadUrlRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <DownloadUrlRecord>[],
    );

Map<String, dynamic> _$DownloadUrlListToJson(_DownloadUrlList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
