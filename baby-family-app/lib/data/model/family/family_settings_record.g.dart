// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_settings_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilySettingsRecord _$FamilySettingsRecordFromJson(
  Map<String, dynamic> json,
) => _FamilySettingsRecord(
  showLunar: json['showLunar'] as bool?,
  circleCanSeeTree: json['circleCanSeeTree'] as bool?,
  defaultVisibility: json['defaultVisibility'] as String?,
  requireCircleReview: json['requireCircleReview'] as bool?,
  traditionalUseLunar: json['traditionalUseLunar'] as bool?,
  milestoneSuggestions: json['milestoneSuggestions'] as bool?,
);

Map<String, dynamic> _$FamilySettingsRecordToJson(
  _FamilySettingsRecord instance,
) => <String, dynamic>{
  'showLunar': instance.showLunar,
  'circleCanSeeTree': instance.circleCanSeeTree,
  'defaultVisibility': instance.defaultVisibility,
  'requireCircleReview': instance.requireCircleReview,
  'traditionalUseLunar': instance.traditionalUseLunar,
  'milestoneSuggestions': instance.milestoneSuggestions,
};
