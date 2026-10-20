// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeProfile _$MeProfileFromJson(Map<String, dynamic> json) => _MeProfile(
  id: json['id'] as String?,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  locale: json['locale'] as String?,
  timezone: json['timezone'] as String?,
  onboardingRole: json['onboardingRole'] as String?,
  profileCompleted: json['profileCompleted'] as bool? ?? false,
  families:
      (json['families'] as List<dynamic>?)
          ?.map((e) => MeFamily.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MeFamily>[],
  awaitingApproval:
      (json['awaitingApproval'] as List<dynamic>?)
          ?.map((e) => MeAwaitingApproval.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MeAwaitingApproval>[],
);

Map<String, dynamic> _$MeProfileToJson(
  _MeProfile instance,
) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'locale': instance.locale,
  'timezone': instance.timezone,
  'onboardingRole': instance.onboardingRole,
  'profileCompleted': instance.profileCompleted,
  'families': instance.families.map((e) => e.toJson()).toList(),
  'awaitingApproval': instance.awaitingApproval.map((e) => e.toJson()).toList(),
};
