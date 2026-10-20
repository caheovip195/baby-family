// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MilestoneCatalog _$MilestoneCatalogFromJson(Map<String, dynamic> json) =>
    _MilestoneCatalog(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (e) =>
                    MilestoneCategoryRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <MilestoneCategoryRecord>[],
    );

Map<String, dynamic> _$MilestoneCatalogToJson(_MilestoneCatalog instance) =>
    <String, dynamic>{
      'categories': instance.categories.map((e) => e.toJson()).toList(),
    };
