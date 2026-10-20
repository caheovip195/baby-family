// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thanks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Thanks _$ThanksFromJson(Map<String, dynamic> json) => _Thanks(
  id: json['id'] as String,
  fromUserId: json['fromUserId'] as String,
  toUserId: json['toUserId'] as String,
  body: json['body'] as String? ?? '',
  sticker: json['sticker'] as String?,
  missionId: json['missionId'] as String?,
  memoryId: json['memoryId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  postedToFamily: json['postedToFamily'] as bool? ?? false,
  shareRequested: json['shareRequested'] as bool? ?? false,
  icon: json['icon'] as String?,
  linkedTitle: json['linkedTitle'] as String?,
  reactedByUserIds:
      (json['reactedByUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$ThanksToJson(_Thanks instance) => <String, dynamic>{
  'id': instance.id,
  'fromUserId': instance.fromUserId,
  'toUserId': instance.toUserId,
  'body': instance.body,
  'sticker': instance.sticker,
  'missionId': instance.missionId,
  'memoryId': instance.memoryId,
  'createdAt': instance.createdAt.toIso8601String(),
  'postedToFamily': instance.postedToFamily,
  'shareRequested': instance.shareRequested,
  'icon': instance.icon,
  'linkedTitle': instance.linkedTitle,
  'reactedByUserIds': instance.reactedByUserIds,
};
