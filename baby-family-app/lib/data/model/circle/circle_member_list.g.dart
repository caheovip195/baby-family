// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_member_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircleMemberList _$CircleMemberListFromJson(Map<String, dynamic> json) =>
    _CircleMemberList(
      members:
          (json['members'] as List<dynamic>?)
              ?.map(
                (e) => CircleMemberRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <CircleMemberRecord>[],
    );

Map<String, dynamic> _$CircleMemberListToJson(_CircleMemberList instance) =>
    <String, dynamic>{
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
