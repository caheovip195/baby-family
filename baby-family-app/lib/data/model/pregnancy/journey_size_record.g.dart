// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_size_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JourneySizeRecord _$JourneySizeRecordFromJson(Map<String, dynamic> json) =>
    _JourneySizeRecord(
      emoji: json['emoji'] as String?,
      lengthCm: json['lengthCm'] as num?,
      weightG: json['weightG'] as num?,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$JourneySizeRecordToJson(_JourneySizeRecord instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'lengthCm': instance.lengthCm,
      'weightG': instance.weightG,
      'label': instance.label,
    };
