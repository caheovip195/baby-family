// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birth_result_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BirthResultRecord _$BirthResultRecordFromJson(Map<String, dynamic> json) =>
    _BirthResultRecord(
      pregnancyId: json['pregnancyId'] as String?,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => ChildRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ChildRecord>[],
    );

Map<String, dynamic> _$BirthResultRecordToJson(_BirthResultRecord instance) =>
    <String, dynamic>{
      'pregnancyId': instance.pregnancyId,
      'children': instance.children.map((e) => e.toJson()).toList(),
    };
