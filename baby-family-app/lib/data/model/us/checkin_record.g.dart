// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CheckinRecord _$CheckinRecordFromJson(Map<String, dynamic> json) =>
    _CheckinRecord(
      id: json['id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      mood: json['mood'] as String?,
      energy: (json['energy'] as num?)?.toInt(),
      needs:
          (json['needs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      note: json['note'] as String?,
      shared: json['shared'] as bool?,
      sharedFields:
          (json['sharedFields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$CheckinRecordToJson(_CheckinRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'mood': instance.mood,
      'energy': instance.energy,
      'needs': instance.needs,
      'note': instance.note,
      'shared': instance.shared,
      'sharedFields': instance.sharedFields,
    };
