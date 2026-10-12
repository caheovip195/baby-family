// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bridge_share.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BridgeShare _$BridgeShareFromJson(Map<String, dynamic> json) => _BridgeShare(
  userId: json['userId'] as String,
  feelings:
      (json['feelings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  needs:
      (json['needs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  topic: json['topic'] as String?,
  message: json['message'] as String?,
  understood: json['understood'] as bool? ?? false,
  readDone: json['readDone'] as bool? ?? false,
);

Map<String, dynamic> _$BridgeShareToJson(_BridgeShare instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'feelings': instance.feelings,
      'needs': instance.needs,
      'topic': instance.topic,
      'message': instance.message,
      'understood': instance.understood,
      'readDone': instance.readDone,
    };
