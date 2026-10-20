// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prep_group_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrepGroupRecord _$PrepGroupRecordFromJson(Map<String, dynamic> json) =>
    _PrepGroupRecord(
      groupCode: json['groupCode'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => PrepItemRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PrepItemRecord>[],
    );

Map<String, dynamic> _$PrepGroupRecordToJson(_PrepGroupRecord instance) =>
    <String, dynamic>{
      'groupCode': instance.groupCode,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
