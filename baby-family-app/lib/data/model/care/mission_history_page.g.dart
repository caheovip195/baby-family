// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_history_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionHistoryPage _$MissionHistoryPageFromJson(Map<String, dynamic> json) =>
    _MissionHistoryPage(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => MissionRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MissionRecord>[],
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$MissionHistoryPageToJson(_MissionHistoryPage instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
