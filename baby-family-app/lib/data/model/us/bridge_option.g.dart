// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bridge_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BridgeOption _$BridgeOptionFromJson(Map<String, dynamic> json) =>
    _BridgeOption(
      code: json['code'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String?,
      tag: json['tag'] as String?,
    );

Map<String, dynamic> _$BridgeOptionToJson(_BridgeOption instance) =>
    <String, dynamic>{
      'code': instance.code,
      'title': instance.title,
      'icon': instance.icon,
      'tag': instance.tag,
    };
