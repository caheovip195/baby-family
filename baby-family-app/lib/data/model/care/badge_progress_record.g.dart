// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_progress_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BadgeProgressRecord _$BadgeProgressRecordFromJson(Map<String, dynamic> json) =>
    _BadgeProgressRecord(
      current: (json['current'] as num?)?.toInt() ?? 0,
      target: (json['target'] as num?)?.toInt() ?? 0,
      percent: (json['percent'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BadgeProgressRecordToJson(
  _BadgeProgressRecord instance,
) => <String, dynamic>{
  'current': instance.current,
  'target': instance.target,
  'percent': instance.percent,
};
