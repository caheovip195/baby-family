// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_audience.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChildAudience _$ChildAudienceFromJson(Map<String, dynamic> json) =>
    _ChildAudience(
      childId: json['childId'] as String,
      relativeCount: (json['relativeCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ChildAudienceToJson(_ChildAudience instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'relativeCount': instance.relativeCount,
    };
