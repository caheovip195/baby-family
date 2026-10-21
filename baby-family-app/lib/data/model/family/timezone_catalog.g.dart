// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimezoneCatalog _$TimezoneCatalogFromJson(Map<String, dynamic> json) =>
    _TimezoneCatalog(
      version: json['version'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => TimezoneOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TimezoneOption>[],
    );

Map<String, dynamic> _$TimezoneCatalogToJson(_TimezoneCatalog instance) =>
    <String, dynamic>{
      'version': instance.version,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_TimezoneOption _$TimezoneOptionFromJson(Map<String, dynamic> json) =>
    _TimezoneOption(
      id: json['id'] as String,
      label: json['label'] as String? ?? '',
      offsetMinutes: (json['offsetMinutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TimezoneOptionToJson(_TimezoneOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'offsetMinutes': instance.offsetMinutes,
    };
