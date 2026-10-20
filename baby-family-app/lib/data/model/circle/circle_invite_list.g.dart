// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_invite_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircleInviteList _$CircleInviteListFromJson(Map<String, dynamic> json) =>
    _CircleInviteList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => CircleInviteRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <CircleInviteRecord>[],
    );

Map<String, dynamic> _$CircleInviteListToJson(_CircleInviteList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
