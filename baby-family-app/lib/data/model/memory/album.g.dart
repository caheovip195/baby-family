// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Album _$AlbumFromJson(Map<String, dynamic> json) => _Album(
  id: json['id'] as String,
  title: json['title'] as String,
  isAuto: json['isAuto'] as bool? ?? false,
  autoCode: json['autoCode'] as String?,
  coverAsset: json['coverAsset'] as String?,
  coverIcon: json['coverIcon'] as String?,
  memoryCount: (json['memoryCount'] as num?)?.toInt() ?? 0,
  childIds:
      (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdByUserId: json['createdByUserId'] as String?,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  visibility:
      $enumDecodeNullable(_$MemoryVisibilityEnumMap, json['visibility']) ??
      MemoryVisibility.family,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => AlbumItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$AlbumToJson(_Album instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'isAuto': instance.isAuto,
  'autoCode': instance.autoCode,
  'coverAsset': instance.coverAsset,
  'coverIcon': instance.coverIcon,
  'memoryCount': instance.memoryCount,
  'childIds': instance.childIds,
  'createdByUserId': instance.createdByUserId,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'visibility': _$MemoryVisibilityEnumMap[instance.visibility]!,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

const _$MemoryVisibilityEnumMap = {
  MemoryVisibility.family: 'family',
  MemoryVisibility.parents: 'parents',
  MemoryVisibility.onlyMe: 'onlyMe',
};
