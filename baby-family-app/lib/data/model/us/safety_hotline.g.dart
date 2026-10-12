// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_hotline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SafetyHotline _$SafetyHotlineFromJson(Map<String, dynamic> json) =>
    _SafetyHotline(
      number: json['number'] as String,
      title: json['title'] as String,
      hint: json['hint'] as String?,
    );

Map<String, dynamic> _$SafetyHotlineToJson(_SafetyHotline instance) =>
    <String, dynamic>{
      'number': instance.number,
      'title': instance.title,
      'hint': instance.hint,
    };
