// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileSettings _$ProfileSettingsFromJson(Map<String, dynamic> json) =>
    _ProfileSettings(
      name: json['name'] as String? ?? '',
      callName: json['callName'] as String? ?? '',
      avatarAsset: json['avatarAsset'] as String?,
      signInMethods:
          (json['signInMethods'] as List<dynamic>?)
              ?.map((e) => SignInMethod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      autoTimezone: json['autoTimezone'] as bool? ?? true,
      timezoneLabel: json['timezoneLabel'] as String? ?? '',
    );

Map<String, dynamic> _$ProfileSettingsToJson(_ProfileSettings instance) =>
    <String, dynamic>{
      'name': instance.name,
      'callName': instance.callName,
      'avatarAsset': instance.avatarAsset,
      'signInMethods': instance.signInMethods.map((e) => e.toJson()).toList(),
      'autoTimezone': instance.autoTimezone,
      'timezoneLabel': instance.timezoneLabel,
    };
