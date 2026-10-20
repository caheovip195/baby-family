// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_template_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MilestoneTemplateRecord _$MilestoneTemplateRecordFromJson(
  Map<String, dynamic> json,
) => _MilestoneTemplateRecord(
  code: json['code'] as String?,
  suggestedDate: json['suggestedDate'] == null
      ? null
      : DateTime.parse(json['suggestedDate'] as String),
  achieved: json['achieved'] == null
      ? null
      : MilestoneAchievedRecord.fromJson(
          json['achieved'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$MilestoneTemplateRecordToJson(
  _MilestoneTemplateRecord instance,
) => <String, dynamic>{
  'code': instance.code,
  'suggestedDate': instance.suggestedDate?.toIso8601String(),
  'achieved': instance.achieved?.toJson(),
};
