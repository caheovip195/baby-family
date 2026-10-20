// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionRecord _$SessionRecordFromJson(Map<String, dynamic> json) =>
    _SessionRecord(
      id: json['id'] as String?,
      platform: json['platform'] as String?,
      appVersion: json['appVersion'] as String?,
      deviceModel: json['deviceModel'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastUsedAt: json['lastUsedAt'] == null
          ? null
          : DateTime.parse(json['lastUsedAt'] as String),
      current: json['current'] as bool? ?? false,
    );

Map<String, dynamic> _$SessionRecordToJson(_SessionRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'platform': instance.platform,
      'appVersion': instance.appVersion,
      'deviceModel': instance.deviceModel,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastUsedAt': instance.lastUsedAt?.toIso8601String(),
      'current': instance.current,
    };
