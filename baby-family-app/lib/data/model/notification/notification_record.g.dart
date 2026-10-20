// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationRecord _$NotificationRecordFromJson(Map<String, dynamic> json) =>
    _NotificationRecord(
      id: json['id'] as String?,
      tab: json['tab'] as String?,
      category: json['category'] as String?,
      templateCode: json['templateCode'] as String?,
      params:
          json['params'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      deepLink: json['deepLink'] as String?,
    );

Map<String, dynamic> _$NotificationRecordToJson(_NotificationRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tab': instance.tab,
      'category': instance.category,
      'templateCode': instance.templateCode,
      'params': instance.params,
      'createdAt': instance.createdAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'deepLink': instance.deepLink,
    };
