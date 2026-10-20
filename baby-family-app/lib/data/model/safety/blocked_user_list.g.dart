// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockedUserList _$BlockedUserListFromJson(Map<String, dynamic> json) =>
    _BlockedUserList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => BlockedUserRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <BlockedUserRecord>[],
    );

Map<String, dynamic> _$BlockedUserListToJson(_BlockedUserList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
