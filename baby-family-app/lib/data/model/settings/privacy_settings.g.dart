// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) =>
    _PrivacySettings(
      defaultVisibility:
          $enumDecodeNullable(
            _$MemoryVisibilityEnumMap,
            json['defaultVisibility'],
          ) ??
          MemoryVisibility.family,
      audiences:
          (json['audiences'] as List<dynamic>?)
              ?.map((e) => ChildAudience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      downloadAllowed:
          (json['downloadAllowed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      postAllowed:
          (json['postAllowed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      familyVisibleMemories:
          (json['familyVisibleMemories'] as num?)?.toInt() ?? 0,
      deviceCount: (json['deviceCount'] as num?)?.toInt() ?? 0,
      aiFeatures: (json['aiFeatures'] as num?)?.toInt() ?? 0,
      blockedCount: (json['blockedCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PrivacySettingsToJson(
  _PrivacySettings instance,
) => <String, dynamic>{
  'defaultVisibility': _$MemoryVisibilityEnumMap[instance.defaultVisibility]!,
  'audiences': instance.audiences.map((e) => e.toJson()).toList(),
  'downloadAllowed': instance.downloadAllowed,
  'postAllowed': instance.postAllowed,
  'familyVisibleMemories': instance.familyVisibleMemories,
  'deviceCount': instance.deviceCount,
  'aiFeatures': instance.aiFeatures,
  'blockedCount': instance.blockedCount,
};

const _$MemoryVisibilityEnumMap = {
  MemoryVisibility.family: 'family',
  MemoryVisibility.parents: 'parents',
  MemoryVisibility.onlyMe: 'onlyMe',
};
