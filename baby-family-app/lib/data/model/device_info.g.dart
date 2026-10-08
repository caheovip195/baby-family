// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => _DeviceInfo(
  deviceId: json['deviceId'] as String?,
  deviceType: $enumDecodeNullable(_$DeviceTypeEnumMap, json['platform']),
  osVersion: json['osVersion'] as String?,
  deviceModel: json['deviceModel'] as String?,
  appVersion: json['appVersion'] as String?,
  manufacturer: json['manufacturer'] as String?,
  sdkInt: (json['sdkInt'] as num?)?.toInt(),
);

Map<String, dynamic> _$DeviceInfoToJson(_DeviceInfo instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'platform': _$DeviceTypeEnumMap[instance.deviceType],
      'osVersion': instance.osVersion,
      'deviceModel': instance.deviceModel,
      'appVersion': instance.appVersion,
      'manufacturer': instance.manufacturer,
      'sdkInt': instance.sdkInt,
    };

const _$DeviceTypeEnumMap = {
  DeviceType.android: 'ANDROID',
  DeviceType.ios: 'IOS',
};
