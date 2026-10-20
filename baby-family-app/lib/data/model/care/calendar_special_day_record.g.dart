// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_special_day_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarSpecialDayRecord _$CalendarSpecialDayRecordFromJson(
  Map<String, dynamic> json,
) => _CalendarSpecialDayRecord(
  date: json['date'] as String?,
  type: json['type'] as String?,
  childId: json['childId'] as String?,
  childName: json['childName'] as String?,
  ageYears: (json['ageYears'] as num?)?.toInt(),
  ageMonths: (json['ageMonths'] as num?)?.toInt(),
);

Map<String, dynamic> _$CalendarSpecialDayRecordToJson(
  _CalendarSpecialDayRecord instance,
) => <String, dynamic>{
  'date': instance.date,
  'type': instance.type,
  'childId': instance.childId,
  'childName': instance.childName,
  'ageYears': instance.ageYears,
  'ageMonths': instance.ageMonths,
};
