// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heart_history_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeartHistoryRecord _$HeartHistoryRecordFromJson(Map<String, dynamic> json) =>
    _HeartHistoryRecord(
      at: json['at'] == null ? null : DateTime.parse(json['at'] as String),
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      reason: json['reason'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$HeartHistoryRecordToJson(_HeartHistoryRecord instance) =>
    <String, dynamic>{
      'at': instance.at?.toIso8601String(),
      'amount': instance.amount,
      'reason': instance.reason,
      'title': instance.title,
    };
