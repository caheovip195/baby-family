// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPage _$NotificationPageFromJson(Map<String, dynamic> json) =>
    _NotificationPage(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => NotificationRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <NotificationRecord>[],
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$NotificationPageToJson(_NotificationPage instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
