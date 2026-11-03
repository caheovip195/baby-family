// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiStatusRecord _$AiStatusRecordFromJson(Map<String, dynamic> json) =>
    _AiStatusRecord(
      available: json['available'] as bool? ?? false,
      used: (json['used'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      consented:
          (json['consented'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$AiStatusRecordToJson(_AiStatusRecord instance) =>
    <String, dynamic>{
      'available': instance.available,
      'used': instance.used,
      'total': instance.total,
      'consented': instance.consented,
    };

_AiDraftRecord _$AiDraftRecordFromJson(Map<String, dynamic> json) =>
    _AiDraftRecord(
      invocationId: json['invocationId'] as String?,
      suggestions:
          (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      story: json['story'] as String?,
      summary: json['summary'] as String?,
      safety: json['safety'] as bool? ?? false,
      neutral: json['neutral'] as String?,
      warm: json['warm'] as String?,
      short: json['short'] as String?,
      missions: json['missions'] == null
          ? const <AiMissionPick>[]
          : _missionPicks(json['missions']),
    );

Map<String, dynamic> _$AiDraftRecordToJson(_AiDraftRecord instance) =>
    <String, dynamic>{
      'invocationId': instance.invocationId,
      'suggestions': instance.suggestions,
      'story': instance.story,
      'summary': instance.summary,
      'safety': instance.safety,
      'neutral': instance.neutral,
      'warm': instance.warm,
      'short': instance.short,
      'missions': instance.missions.map((e) => e.toJson()).toList(),
    };

_AiMissionPick _$AiMissionPickFromJson(Map<String, dynamic> json) =>
    _AiMissionPick(
      templateId: json['templateId'] as String,
      title: json['title'] as String? ?? '',
      category: json['category'] as String?,
      hearts: (json['hearts'] as num?)?.toInt() ?? 0,
      durationMin: (json['durationMin'] as num?)?.toInt(),
      reason: json['reason'] as String? ?? '',
    );

Map<String, dynamic> _$AiMissionPickToJson(_AiMissionPick instance) =>
    <String, dynamic>{
      'templateId': instance.templateId,
      'title': instance.title,
      'category': instance.category,
      'hearts': instance.hearts,
      'durationMin': instance.durationMin,
      'reason': instance.reason,
    };
