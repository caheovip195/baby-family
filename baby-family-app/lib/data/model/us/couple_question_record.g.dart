// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple_question_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoupleQuestionRecord _$CoupleQuestionRecordFromJson(
  Map<String, dynamic> json,
) => _CoupleQuestionRecord(
  date: json['date'] as String?,
  code: json['code'] as String?,
  textI18n:
      (json['textI18n'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  myAnswer: json['myAnswer'] as String?,
  partnerAnswered: json['partnerAnswered'] as bool? ?? false,
  partnerAnswer: json['partnerAnswer'] as String?,
);

Map<String, dynamic> _$CoupleQuestionRecordToJson(
  _CoupleQuestionRecord instance,
) => <String, dynamic>{
  'date': instance.date,
  'code': instance.code,
  'textI18n': instance.textI18n,
  'myAnswer': instance.myAnswer,
  'partnerAnswered': instance.partnerAnswered,
  'partnerAnswer': instance.partnerAnswer,
};

_CoupleWeekRecord _$CoupleWeekRecordFromJson(Map<String, dynamic> json) =>
    _CoupleWeekRecord(
      weekStart: json['weekStart'] as String?,
      weekEnd: json['weekEnd'] as String?,
      checkins: (json['checkins'] as num?)?.toInt() ?? 0,
      requestsHelped: (json['requestsHelped'] as num?)?.toInt() ?? 0,
      thanks: (json['thanks'] as num?)?.toInt() ?? 0,
      togetherMissions: (json['togetherMissions'] as num?)?.toInt() ?? 0,
      together:
          (json['together'] as List<dynamic>?)
              ?.map(
                (e) => CoupleWeekTogetherRecord.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const <CoupleWeekTogetherRecord>[],
    );

Map<String, dynamic> _$CoupleWeekRecordToJson(_CoupleWeekRecord instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart,
      'weekEnd': instance.weekEnd,
      'checkins': instance.checkins,
      'requestsHelped': instance.requestsHelped,
      'thanks': instance.thanks,
      'togetherMissions': instance.togetherMissions,
      'together': instance.together.map((e) => e.toJson()).toList(),
    };

_CoupleWeekTogetherRecord _$CoupleWeekTogetherRecordFromJson(
  Map<String, dynamic> json,
) => _CoupleWeekTogetherRecord(
  title: json['title'] as String?,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$CoupleWeekTogetherRecordToJson(
  _CoupleWeekTogetherRecord instance,
) => <String, dynamic>{
  'title': instance.title,
  'date': instance.date?.toIso8601String(),
};
