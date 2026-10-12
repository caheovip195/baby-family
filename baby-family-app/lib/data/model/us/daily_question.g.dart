// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyQuestion _$DailyQuestionFromJson(Map<String, dynamic> json) =>
    _DailyQuestion(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      text: json['text'] as String,
      myAnswer: json['myAnswer'] as String?,
      partnerAnswer: json['partnerAnswer'] as String?,
      partnerAnswered: json['partnerAnswered'] as bool? ?? false,
    );

Map<String, dynamic> _$DailyQuestionToJson(_DailyQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'text': instance.text,
      'myAnswer': instance.myAnswer,
      'partnerAnswer': instance.partnerAnswer,
      'partnerAnswered': instance.partnerAnswered,
    };
