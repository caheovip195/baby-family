// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StorageUsage _$StorageUsageFromJson(Map<String, dynamic> json) =>
    _StorageUsage(
      kind: json['kind'] as String,
      usedMb: (json['usedMb'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StorageUsageToJson(_StorageUsage instance) =>
    <String, dynamic>{'kind': instance.kind, 'usedMb': instance.usedMb};
