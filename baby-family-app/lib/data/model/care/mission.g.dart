// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Mission _$MissionFromJson(Map<String, dynamic> json) => _Mission(
  id: json['id'] as String,
  title: json['title'] as String,
  category:
      $enumDecodeNullable(_$MissionCategoryEnumMap, json['category']) ??
      MissionCategory.care,
  hearts: (json['hearts'] as num?)?.toInt(),
  ownerKind:
      $enumDecodeNullable(_$MissionOwnerKindEnumMap, json['ownerKind']) ??
      MissionOwnerKind.me,
  source:
      $enumDecodeNullable(_$MissionSourceEnumMap, json['source']) ??
      MissionSource.system,
  templateId: json['templateId'] as String?,
  childIds:
      (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  date: DateTime.parse(json['date'] as String),
  dueTime: json['dueTime'] as String?,
  durationMin: (json['durationMin'] as num?)?.toInt(),
  icon: json['icon'] as String?,
  status:
      $enumDecodeNullable(_$MissionStatusEnumMap, json['status']) ??
      MissionStatus.todo,
  repeat:
      $enumDecodeNullable(_$MissionRepeatEnumMap, json['repeat']) ??
      MissionRepeat.none,
  reminder:
      $enumDecodeNullable(_$MissionReminderEnumMap, json['reminder']) ??
      MissionReminder.none,
  late: json['late'] as bool? ?? false,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  thankedByPartner: json['thankedByPartner'] as bool? ?? false,
  note: json['note'] as String?,
);

Map<String, dynamic> _$MissionToJson(_Mission instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'category': _$MissionCategoryEnumMap[instance.category]!,
  'hearts': instance.hearts,
  'ownerKind': _$MissionOwnerKindEnumMap[instance.ownerKind]!,
  'source': _$MissionSourceEnumMap[instance.source]!,
  'templateId': instance.templateId,
  'childIds': instance.childIds,
  'date': instance.date.toIso8601String(),
  'dueTime': instance.dueTime,
  'durationMin': instance.durationMin,
  'icon': instance.icon,
  'status': _$MissionStatusEnumMap[instance.status]!,
  'repeat': _$MissionRepeatEnumMap[instance.repeat]!,
  'reminder': _$MissionReminderEnumMap[instance.reminder]!,
  'late': instance.late,
  'completedAt': instance.completedAt?.toIso8601String(),
  'thankedByPartner': instance.thankedByPartner,
  'note': instance.note,
};

const _$MissionCategoryEnumMap = {
  MissionCategory.care: 'care',
  MissionCategory.bonding: 'bonding',
  MissionCategory.outing: 'outing',
  MissionCategory.memory: 'memory',
  MissionCategory.support: 'support',
  MissionCategory.self: 'self',
  MissionCategory.together: 'together',
  MissionCategory.couple: 'couple',
  MissionCategory.custom: 'custom',
};

const _$MissionOwnerKindEnumMap = {
  MissionOwnerKind.me: 'me',
  MissionOwnerKind.partner: 'partner',
  MissionOwnerKind.together: 'together',
};

const _$MissionSourceEnumMap = {
  MissionSource.system: 'system',
  MissionSource.library: 'library',
  MissionSource.custom: 'custom',
  MissionSource.series: 'series',
};

const _$MissionStatusEnumMap = {
  MissionStatus.todo: 'todo',
  MissionStatus.done: 'done',
  MissionStatus.expired: 'expired',
  MissionStatus.removed: 'removed',
};

const _$MissionRepeatEnumMap = {
  MissionRepeat.none: 'none',
  MissionRepeat.daily: 'daily',
  MissionRepeat.weekdays: 'weekdays',
  MissionRepeat.weekends: 'weekends',
  MissionRepeat.customDays: 'customDays',
};

const _$MissionReminderEnumMap = {
  MissionReminder.none: 'none',
  MissionReminder.atTime: 'atTime',
  MissionReminder.before15: 'before15',
  MissionReminder.before30: 'before30',
  MissionReminder.before60: 'before60',
};
