// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple_week_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoupleWeekItem _$CoupleWeekItemFromJson(Map<String, dynamic> json) =>
    _CoupleWeekItem(
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$CoupleWeekItemToJson(_CoupleWeekItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'date': instance.date.toIso8601String(),
    };
