// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BadgeList _$BadgeListFromJson(Map<String, dynamic> json) => _BadgeList(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => BadgeRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BadgeRecord>[],
);

Map<String, dynamic> _$BadgeListToJson(_BadgeList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
