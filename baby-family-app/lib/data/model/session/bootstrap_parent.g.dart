// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bootstrap_parent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BootstrapParent _$BootstrapParentFromJson(Map<String, dynamic> json) =>
    _BootstrapParent(
      userId: json['userId'] as String?,
      slot: json['slot'] as String?,
      kind: json['kind'] as String?,
      callName: json['callName'] as String?,
      displayName: json['displayName'] as String?,
    );

Map<String, dynamic> _$BootstrapParentToJson(_BootstrapParent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'slot': instance.slot,
      'kind': instance.kind,
      'callName': instance.callName,
      'displayName': instance.displayName,
    };
