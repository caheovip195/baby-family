// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrowthEntry _$GrowthEntryFromJson(Map<String, dynamic> json) => _GrowthEntry(
  measuredOn: json['measuredOn'] as String,
  weightGrams: (json['weightGrams'] as num?)?.toInt(),
  heightMm: (json['heightMm'] as num?)?.toInt(),
  note: json['note'] as String?,
  pending: json['pending'] as bool? ?? false,
);

Map<String, dynamic> _$GrowthEntryToJson(_GrowthEntry instance) =>
    <String, dynamic>{
      'measuredOn': instance.measuredOn,
      'weightGrams': instance.weightGrams,
      'heightMm': instance.heightMm,
      'note': instance.note,
      'pending': instance.pending,
    };

_GrowthListRecord _$GrowthListRecordFromJson(Map<String, dynamic> json) =>
    _GrowthListRecord(
      childId: json['childId'] as String?,
      birthDate: json['birthDate'] as String?,
      items: json['items'] == null
          ? const <GrowthEntry>[]
          : _growthItems(json['items']),
    );

Map<String, dynamic> _$GrowthListRecordToJson(_GrowthListRecord instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'birthDate': instance.birthDate,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
