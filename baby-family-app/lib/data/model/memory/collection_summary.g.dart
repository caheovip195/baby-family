// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollectionSummary _$CollectionSummaryFromJson(Map<String, dynamic> json) =>
    _CollectionSummary(
      code: json['code'] as String,
      title: json['title'] as String,
      coverAsset: json['coverAsset'] as String?,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CollectionSummaryToJson(_CollectionSummary instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'coverAsset': instance.coverAsset,
      'count': instance.count,
    };
