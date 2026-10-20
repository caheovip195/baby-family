// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_reminder_rule_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventReminderRuleRecord _$EventReminderRuleRecordFromJson(
  Map<String, dynamic> json,
) => _EventReminderRuleRecord(
  recipientUserId: json['recipientUserId'] as String?,
  offsetMinutes: (json['offsetMinutes'] as num?)?.toInt(),
  enabled: json['enabled'] as bool? ?? true,
);

Map<String, dynamic> _$EventReminderRuleRecordToJson(
  _EventReminderRuleRecord instance,
) => <String, dynamic>{
  'recipientUserId': instance.recipientUserId,
  'offsetMinutes': instance.offsetMinutes,
  'enabled': instance.enabled,
};
