// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilySettings _$FamilySettingsFromJson(Map<String, dynamic> json) =>
    _FamilySettings(
      name: json['name'] as String? ?? '',
      coverAsset: json['coverAsset'] as String?,
      defaultVisibility:
          $enumDecodeNullable(
            _$MemoryVisibilityEnumMap,
            json['defaultVisibility'],
          ) ??
          MemoryVisibility.family,
      approveRelativePhotos: json['approveRelativePhotos'] as bool? ?? true,
      relativesSeeTree: json['relativesSeeTree'] as bool? ?? true,
      milestoneSuggestions: json['milestoneSuggestions'] as bool? ?? true,
      timezoneLabel: json['timezoneLabel'] as String? ?? '',
      showLunar: json['showLunar'] as bool? ?? true,
      milestonesByLunar: json['milestonesByLunar'] as bool? ?? true,
      contentLanguage: json['contentLanguage'] as String? ?? 'vi',
    );

Map<String, dynamic> _$FamilySettingsToJson(
  _FamilySettings instance,
) => <String, dynamic>{
  'name': instance.name,
  'coverAsset': instance.coverAsset,
  'defaultVisibility': _$MemoryVisibilityEnumMap[instance.defaultVisibility]!,
  'approveRelativePhotos': instance.approveRelativePhotos,
  'relativesSeeTree': instance.relativesSeeTree,
  'milestoneSuggestions': instance.milestoneSuggestions,
  'timezoneLabel': instance.timezoneLabel,
  'showLunar': instance.showLunar,
  'milestonesByLunar': instance.milestonesByLunar,
  'contentLanguage': instance.contentLanguage,
};

const _$MemoryVisibilityEnumMap = {
  MemoryVisibility.family: 'family',
  MemoryVisibility.parents: 'parents',
  MemoryVisibility.onlyMe: 'onlyMe',
};
