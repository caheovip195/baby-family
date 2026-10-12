// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MilestoneItem _$MilestoneItemFromJson(Map<String, dynamic> json) =>
    _MilestoneItem(
      code: json['code'] as String,
      title: json['title'] as String,
      forPregnancy: json['forPregnancy'] as bool? ?? false,
      typicalAgeDays: (json['typicalAgeDays'] as num?)?.toInt(),
      memoryId: json['memoryId'] as String?,
      achievedAt: json['achievedAt'] == null
          ? null
          : DateTime.parse(json['achievedAt'] as String),
      asset: json['asset'] as String?,
    );

Map<String, dynamic> _$MilestoneItemToJson(_MilestoneItem instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'forPregnancy': instance.forPregnancy,
      'typicalAgeDays': instance.typicalAgeDays,
      'memoryId': instance.memoryId,
      'achievedAt': instance.achievedAt?.toIso8601String(),
      'asset': instance.asset,
    };
