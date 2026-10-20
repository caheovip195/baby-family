// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_category_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportCategoryCatalog _$SupportCategoryCatalogFromJson(
  Map<String, dynamic> json,
) => _SupportCategoryCatalog(
  version: (json['version'] as num?)?.toInt(),
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$SupportCategoryCatalogToJson(
  _SupportCategoryCatalog instance,
) => <String, dynamic>{
  'version': instance.version,
  'categories': instance.categories,
};
