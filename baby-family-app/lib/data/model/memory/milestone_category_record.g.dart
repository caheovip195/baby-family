// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_category_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MilestoneCategoryRecord _$MilestoneCategoryRecordFromJson(
  Map<String, dynamic> json,
) => _MilestoneCategoryRecord(
  category: json['category'] as String?,
  templates:
      (json['templates'] as List<dynamic>?)
          ?.map(
            (e) => MilestoneTemplateRecord.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <MilestoneTemplateRecord>[],
);

Map<String, dynamic> _$MilestoneCategoryRecordToJson(
  _MilestoneCategoryRecord instance,
) => <String, dynamic>{
  'category': instance.category,
  'templates': instance.templates.map((e) => e.toJson()).toList(),
};
