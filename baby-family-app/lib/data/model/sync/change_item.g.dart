// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangeItem _$ChangeItemFromJson(Map<String, dynamic> json) => _ChangeItem(
  entity: json['entity'] as String,
  id: json['id'] as String,
  memoryId: json['memoryId'] as String?,
  op: json['op'] as String,
  version: (json['version'] as num?)?.toInt(),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  data: json['data'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ChangeItemToJson(_ChangeItem instance) =>
    <String, dynamic>{
      'entity': instance.entity,
      'id': instance.id,
      'memoryId': instance.memoryId,
      'op': instance.op,
      'version': instance.version,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'data': instance.data,
    };

_ChangesPage _$ChangesPageFromJson(Map<String, dynamic> json) => _ChangesPage(
  items: json['items'] == null ? const [] : _changeItems(json['items']),
  nextCursor: json['nextCursor'] as String?,
  hasMore: json['hasMore'] as bool? ?? false,
);

Map<String, dynamic> _$ChangesPageToJson(_ChangesPage instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
      'hasMore': instance.hasMore,
    };
