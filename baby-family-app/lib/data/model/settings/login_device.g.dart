// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginDevice _$LoginDeviceFromJson(Map<String, dynamic> json) => _LoginDevice(
  id: json['id'] as String,
  name: json['name'] as String,
  kind:
      $enumDecodeNullable(_$DeviceKindEnumMap, json['kind']) ??
      DeviceKind.phone,
  location: json['location'] as String? ?? '',
  lastActiveAt: json['lastActiveAt'] == null
      ? null
      : DateTime.parse(json['lastActiveAt'] as String),
  current: json['current'] as bool? ?? false,
);

Map<String, dynamic> _$LoginDeviceToJson(_LoginDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kind': _$DeviceKindEnumMap[instance.kind]!,
      'location': instance.location,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
      'current': instance.current,
    };

const _$DeviceKindEnumMap = {
  DeviceKind.phone: 'phone',
  DeviceKind.tablet: 'tablet',
};
