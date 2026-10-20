// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarEventRecord _$CalendarEventRecordFromJson(Map<String, dynamic> json) =>
    _CalendarEventRecord(
      id: json['id'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      notes: json['notes'] as String?,
      allDay: json['allDay'] as bool? ?? false,
      startAt: json['startAt'] == null
          ? null
          : DateTime.parse(json['startAt'] as String),
      localStartDate: json['localStartDate'] as String?,
      occurrenceDate: json['occurrenceDate'] as String?,
      isLunar: json['isLunar'] as bool? ?? false,
      lunarMonth: (json['lunarMonth'] as num?)?.toInt(),
      lunarDay: (json['lunarDay'] as num?)?.toInt(),
      repeatYearly: json['repeatYearly'] as bool? ?? false,
      inviteCircle: json['inviteCircle'] as bool? ?? false,
      childIds:
          (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map(
                (e) =>
                    EventParticipantRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <EventParticipantRecord>[],
      reminderRules:
          (json['reminderRules'] as List<dynamic>?)
              ?.map(
                (e) =>
                    EventReminderRuleRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <EventReminderRuleRecord>[],
    );

Map<String, dynamic> _$CalendarEventRecordToJson(
  _CalendarEventRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'notes': instance.notes,
  'allDay': instance.allDay,
  'startAt': instance.startAt?.toIso8601String(),
  'localStartDate': instance.localStartDate,
  'occurrenceDate': instance.occurrenceDate,
  'isLunar': instance.isLunar,
  'lunarMonth': instance.lunarMonth,
  'lunarDay': instance.lunarDay,
  'repeatYearly': instance.repeatYearly,
  'inviteCircle': instance.inviteCircle,
  'childIds': instance.childIds,
  'participants': instance.participants.map((e) => e.toJson()).toList(),
  'reminderRules': instance.reminderRules.map((e) => e.toJson()).toList(),
};
