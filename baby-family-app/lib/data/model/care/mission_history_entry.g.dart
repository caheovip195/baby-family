// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionHistoryEntry _$MissionHistoryEntryFromJson(Map<String, dynamic> json) =>
    _MissionHistoryEntry(
      title: json['title'] as String,
      ownerKind:
          $enumDecodeNullable(_$MissionOwnerKindEnumMap, json['ownerKind']) ??
          MissionOwnerKind.me,
      done: json['done'] as bool? ?? true,
      completedTime: json['completedTime'] as String?,
      categoryCode: json['categoryCode'] as String?,
      hearts: (json['hearts'] as num?)?.toInt(),
      childIds:
          (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      couple: json['couple'] as bool? ?? false,
    );

Map<String, dynamic> _$MissionHistoryEntryToJson(
  _MissionHistoryEntry instance,
) => <String, dynamic>{
  'title': instance.title,
  'ownerKind': _$MissionOwnerKindEnumMap[instance.ownerKind]!,
  'done': instance.done,
  'completedTime': instance.completedTime,
  'categoryCode': instance.categoryCode,
  'hearts': instance.hearts,
  'childIds': instance.childIds,
  'couple': instance.couple,
};

const _$MissionOwnerKindEnumMap = {
  MissionOwnerKind.me: 'me',
  MissionOwnerKind.partner: 'partner',
  MissionOwnerKind.together: 'together',
};
