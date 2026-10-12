// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyMembership _$FamilyMembershipFromJson(Map<String, dynamic> json) =>
    _FamilyMembership(
      familyId: json['familyId'] as String,
      familyName: json['familyName'] as String,
      role: $enumDecode(_$FamilyRoleEnumMap, json['role']),
      callName: json['callName'] as String? ?? '',
      childNames:
          (json['childNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      partnerName: json['partnerName'] as String?,
      permissionSummary: json['permissionSummary'] as String?,
      current: json['current'] as bool? ?? false,
    );

Map<String, dynamic> _$FamilyMembershipToJson(_FamilyMembership instance) =>
    <String, dynamic>{
      'familyId': instance.familyId,
      'familyName': instance.familyName,
      'role': _$FamilyRoleEnumMap[instance.role]!,
      'callName': instance.callName,
      'childNames': instance.childNames,
      'partnerName': instance.partnerName,
      'permissionSummary': instance.permissionSummary,
      'current': instance.current,
    };

const _$FamilyRoleEnumMap = {
  FamilyRole.father: 'father',
  FamilyRole.mother: 'mother',
  FamilyRole.relative: 'relative',
};
