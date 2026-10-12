// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChildProfile _$ChildProfileFromJson(Map<String, dynamic> json) =>
    _ChildProfile(
      childId: json['childId'] as String,
      fullName: json['fullName'] as String?,
      gestationWeeks: (json['gestationWeeks'] as num?)?.toInt(),
      showBirthTimeToRelatives:
          json['showBirthTimeToRelatives'] as bool? ?? false,
      nameStory: json['nameStory'] as String?,
      nameGivenBy:
          (json['nameGivenBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      favoriteFood: json['favoriteFood'] as String?,
      favoriteToy: json['favoriteToy'] as String?,
      favoriteSong: json['favoriteSong'] as String?,
      memoryCount: (json['memoryCount'] as num?)?.toInt() ?? 0,
      milestoneCount: (json['milestoneCount'] as num?)?.toInt() ?? 0,
      letterCount: (json['letterCount'] as num?)?.toInt() ?? 0,
      privateMemoryCount: (json['privateMemoryCount'] as num?)?.toInt() ?? 0,
      relativeViewerNames:
          (json['relativeViewerNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ChildProfileToJson(_ChildProfile instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'fullName': instance.fullName,
      'gestationWeeks': instance.gestationWeeks,
      'showBirthTimeToRelatives': instance.showBirthTimeToRelatives,
      'nameStory': instance.nameStory,
      'nameGivenBy': instance.nameGivenBy,
      'favoriteFood': instance.favoriteFood,
      'favoriteToy': instance.favoriteToy,
      'favoriteSong': instance.favoriteSong,
      'memoryCount': instance.memoryCount,
      'milestoneCount': instance.milestoneCount,
      'letterCount': instance.letterCount,
      'privateMemoryCount': instance.privateMemoryCount,
      'relativeViewerNames': instance.relativeViewerNames,
    };
