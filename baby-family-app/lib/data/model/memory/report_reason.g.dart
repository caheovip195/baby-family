// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_reason.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportReason _$ReportReasonFromJson(Map<String, dynamic> json) =>
    _ReportReason(
      code: json['code'] as String,
      title: json['title'] as String,
      hint: json['hint'] as String?,
      note: json['note'] as String?,
      priority: json['priority'] as bool? ?? false,
    );

Map<String, dynamic> _$ReportReasonToJson(_ReportReason instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'hint': instance.hint,
      'note': instance.note,
      'priority': instance.priority,
    };
