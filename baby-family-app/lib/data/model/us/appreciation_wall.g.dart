// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appreciation_wall.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppreciationWall _$AppreciationWallFromJson(Map<String, dynamic> json) =>
    _AppreciationWall(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => AppreciationRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <AppreciationRecord>[],
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$AppreciationWallToJson(_AppreciationWall instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
