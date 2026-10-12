// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple_week.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoupleWeek _$CoupleWeekFromJson(Map<String, dynamic> json) => _CoupleWeek(
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  headline: json['headline'] as String? ?? '',
  checkins: (json['checkins'] as num?)?.toInt() ?? 0,
  requestsHelped: (json['requestsHelped'] as num?)?.toInt() ?? 0,
  thanks: (json['thanks'] as num?)?.toInt() ?? 0,
  togetherMissions: (json['togetherMissions'] as num?)?.toInt() ?? 0,
  highlightThanks: json['highlightThanks'] as String?,
  highlightByUserId: json['highlightByUserId'] as String?,
  highlightAt: json['highlightAt'] == null
      ? null
      : DateTime.parse(json['highlightAt'] as String),
  together:
      (json['together'] as List<dynamic>?)
          ?.map((e) => CoupleWeekItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CoupleWeekToJson(_CoupleWeek instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'headline': instance.headline,
      'checkins': instance.checkins,
      'requestsHelped': instance.requestsHelped,
      'thanks': instance.thanks,
      'togetherMissions': instance.togetherMissions,
      'highlightThanks': instance.highlightThanks,
      'highlightByUserId': instance.highlightByUserId,
      'highlightAt': instance.highlightAt?.toIso8601String(),
      'together': instance.together.map((e) => e.toJson()).toList(),
    };
