// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiSettings _$AiSettingsFromJson(Map<String, dynamic> json) => _AiSettings(
  enabled: json['enabled'] as bool? ?? true,
  remaining: (json['remaining'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  renewsAt: json['renewsAt'] == null
      ? null
      : DateTime.parse(json['renewsAt'] as String),
  features:
      (json['features'] as List<dynamic>?)
          ?.map((e) => AiFeatureSetting.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$AiSettingsToJson(_AiSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'remaining': instance.remaining,
      'total': instance.total,
      'renewsAt': instance.renewsAt?.toIso8601String(),
      'features': instance.features.map((e) => e.toJson()).toList(),
    };
