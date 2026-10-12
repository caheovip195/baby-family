// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarEvent _$CalendarEventFromJson(
  Map<String, dynamic> json,
) => _CalendarEvent(
  id: json['id'] as String,
  title: json['title'] as String,
  kind:
      $enumDecodeNullable(_$CalendarEventKindEnumMap, json['kind']) ??
      CalendarEventKind.family,
  date: DateTime.parse(json['date'] as String),
  time: json['time'] as String?,
  allDay: json['allDay'] as bool? ?? false,
  icon: json['icon'] as String?,
  childIds:
      (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  participantUserIds:
      (json['participantUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  lunar: json['lunar'] as bool? ?? false,
  lunarDay: (json['lunarDay'] as num?)?.toInt(),
  lunarMonth: (json['lunarMonth'] as num?)?.toInt(),
  repeatYearly: json['repeatYearly'] as bool? ?? false,
  inviteFamily: json['inviteFamily'] as bool? ?? false,
  reminders:
      (json['reminders'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  ownerKind: $enumDecodeNullable(_$MissionOwnerKindEnumMap, json['ownerKind']),
  missionId: json['missionId'] as String?,
);

Map<String, dynamic> _$CalendarEventToJson(_CalendarEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'kind': _$CalendarEventKindEnumMap[instance.kind]!,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'allDay': instance.allDay,
      'icon': instance.icon,
      'childIds': instance.childIds,
      'participantUserIds': instance.participantUserIds,
      'lunar': instance.lunar,
      'lunarDay': instance.lunarDay,
      'lunarMonth': instance.lunarMonth,
      'repeatYearly': instance.repeatYearly,
      'inviteFamily': instance.inviteFamily,
      'reminders': instance.reminders,
      'ownerKind': _$MissionOwnerKindEnumMap[instance.ownerKind],
      'missionId': instance.missionId,
    };

const _$CalendarEventKindEnumMap = {
  CalendarEventKind.child: 'child',
  CalendarEventKind.family: 'family',
  CalendarEventKind.couple: 'couple',
  CalendarEventKind.anniversary: 'anniversary',
  CalendarEventKind.health: 'health',
  CalendarEventKind.mission: 'mission',
};

const _$MissionOwnerKindEnumMap = {
  MissionOwnerKind.me: 'me',
  MissionOwnerKind.partner: 'partner',
  MissionOwnerKind.together: 'together',
};
