// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_feature_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiFeatureSetting _$AiFeatureSettingFromJson(Map<String, dynamic> json) =>
    _AiFeatureSetting(
      code: json['code'] as String,
      title: json['title'] as String,
      sends: json['sends'] as String?,
      icon: json['icon'] as String?,
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$AiFeatureSettingToJson(_AiFeatureSetting instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'sends': instance.sends,
      'icon': instance.icon,
      'enabled': instance.enabled,
    };
