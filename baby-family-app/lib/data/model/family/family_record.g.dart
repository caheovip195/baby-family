// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyRecord _$FamilyRecordFromJson(Map<String, dynamic> json) =>
    _FamilyRecord(
      id: json['id'] as String?,
      name: json['name'] as String?,
      timezone: json['timezone'] as String?,
      contentLocale: json['contentLocale'] as String?,
      coverUrl: json['coverUrl'] as String?,
    );

Map<String, dynamic> _$FamilyRecordToJson(_FamilyRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'timezone': instance.timezone,
      'contentLocale': instance.contentLocale,
      'coverUrl': instance.coverUrl,
    };
