// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryCount _$CategoryCountFromJson(Map<String, dynamic> json) =>
    _CategoryCount(
      code: json['code'] as String,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CategoryCountToJson(_CategoryCount instance) =>
    <String, dynamic>{'code': instance.code, 'count': instance.count};
