// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prep_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrepSummary _$PrepSummaryFromJson(Map<String, dynamic> json) => _PrepSummary(
  done: (json['done'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => PrepItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PrepSummaryToJson(_PrepSummary instance) =>
    <String, dynamic>{
      'done': instance.done,
      'total': instance.total,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
