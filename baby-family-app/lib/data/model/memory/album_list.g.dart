// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlbumList _$AlbumListFromJson(Map<String, dynamic> json) => _AlbumList(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => AlbumRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AlbumRecord>[],
);

Map<String, dynamic> _$AlbumListToJson(_AlbumList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
