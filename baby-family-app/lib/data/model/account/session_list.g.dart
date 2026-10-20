// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionList _$SessionListFromJson(Map<String, dynamic> json) => _SessionList(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => SessionRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SessionRecord>[],
);

Map<String, dynamic> _$SessionListToJson(_SessionList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
