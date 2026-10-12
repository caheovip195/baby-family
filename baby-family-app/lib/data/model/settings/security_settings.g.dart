// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SecuritySettings _$SecuritySettingsFromJson(Map<String, dynamic> json) =>
    _SecuritySettings(
      faceIdLock: json['faceIdLock'] as bool? ?? true,
      pinSet: json['pinSet'] as bool? ?? true,
      devices:
          (json['devices'] as List<dynamic>?)
              ?.map((e) => LoginDevice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SecuritySettingsToJson(_SecuritySettings instance) =>
    <String, dynamic>{
      'faceIdLock': instance.faceIdLock,
      'pinSet': instance.pinSet,
      'devices': instance.devices.map((e) => e.toJson()).toList(),
    };
