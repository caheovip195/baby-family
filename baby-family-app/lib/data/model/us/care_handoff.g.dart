// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_handoff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CareHandoff _$CareHandoffFromJson(Map<String, dynamic> json) => _CareHandoff(
  id: json['id'] as String,
  direction: json['direction'] as String? ?? 'SENT',
  childIds:
      (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  fedAt: json['fedAt'] == null ? null : DateTime.parse(json['fedAt'] as String),
  sleptAt: json['sleptAt'] == null
      ? null
      : DateTime.parse(json['sleptAt'] as String),
  wokeAt: json['wokeAt'] == null
      ? null
      : DateTime.parse(json['wokeAt'] as String),
  note: json['note'] as String?,
  acknowledgedAt: json['acknowledgedAt'] == null
      ? null
      : DateTime.parse(json['acknowledgedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  pending: json['pending'] as bool? ?? false,
);

Map<String, dynamic> _$CareHandoffToJson(_CareHandoff instance) =>
    <String, dynamic>{
      'id': instance.id,
      'direction': instance.direction,
      'childIds': instance.childIds,
      'fedAt': instance.fedAt?.toIso8601String(),
      'sleptAt': instance.sleptAt?.toIso8601String(),
      'wokeAt': instance.wokeAt?.toIso8601String(),
      'note': instance.note,
      'acknowledgedAt': instance.acknowledgedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'pending': instance.pending,
    };
