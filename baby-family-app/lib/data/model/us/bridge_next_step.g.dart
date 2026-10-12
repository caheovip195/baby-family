// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bridge_next_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BridgeNextStep _$BridgeNextStepFromJson(Map<String, dynamic> json) =>
    _BridgeNextStep(
      code: json['code'] as String,
      whenLabel: json['whenLabel'] as String?,
      at: json['at'] == null ? null : DateTime.parse(json['at'] as String),
      childIds:
          (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      reminder: json['reminder'] as bool? ?? true,
      reminderAt: json['reminderAt'] == null
          ? null
          : DateTime.parse(json['reminderAt'] as String),
      agreedUserIds:
          (json['agreedUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BridgeNextStepToJson(_BridgeNextStep instance) =>
    <String, dynamic>{
      'code': instance.code,
      'whenLabel': instance.whenLabel,
      'at': instance.at?.toIso8601String(),
      'childIds': instance.childIds,
      'reminder': instance.reminder,
      'reminderAt': instance.reminderAt?.toIso8601String(),
      'agreedUserIds': instance.agreedUserIds,
    };
