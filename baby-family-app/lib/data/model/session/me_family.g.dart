// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_family.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeFamily _$MeFamilyFromJson(Map<String, dynamic> json) => _MeFamily(
  familyId: json['familyId'] as String?,
  name: json['name'] as String?,
  status: json['status'] as String?,
  slot: json['slot'] as String?,
  kind: json['kind'] as String?,
  callName: json['callName'] as String?,
);

Map<String, dynamic> _$MeFamilyToJson(_MeFamily instance) => <String, dynamic>{
  'familyId': instance.familyId,
  'name': instance.name,
  'status': instance.status,
  'slot': instance.slot,
  'kind': instance.kind,
  'callName': instance.callName,
};
