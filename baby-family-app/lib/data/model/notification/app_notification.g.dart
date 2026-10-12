// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      group:
          $enumDecodeNullable(_$NotificationGroupEnumMap, json['group']) ??
          NotificationGroup.family,
      kind:
          $enumDecodeNullable(_$NotificationKindEnumMap, json['kind']) ??
          NotificationKind.system,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      unread: json['unread'] as bool? ?? false,
      route: json['route'] as String?,
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group': _$NotificationGroupEnumMap[instance.group]!,
      'kind': _$NotificationKindEnumMap[instance.kind]!,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'unread': instance.unread,
      'route': instance.route,
    };

const _$NotificationGroupEnumMap = {
  NotificationGroup.all: 'all',
  NotificationGroup.us: 'us',
  NotificationGroup.family: 'family',
};

const _$NotificationKindEnumMap = {
  NotificationKind.support: 'support',
  NotificationKind.request: 'request',
  NotificationKind.comment: 'comment',
  NotificationKind.tree: 'tree',
  NotificationKind.trial: 'trial',
  NotificationKind.memory: 'memory',
  NotificationKind.mission: 'mission',
  NotificationKind.invite: 'invite',
  NotificationKind.system: 'system',
};
