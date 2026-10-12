import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_profile.freezed.dart';
part 'child_profile.g.dart';

/// Hồ sơ chi tiết của bé (CHD-01/02).
@Freezed(when: FreezedWhenOptions.none)
abstract class ChildProfile with _$ChildProfile {
  @JsonSerializable(explicitToJson: true)
  const factory ChildProfile({
    @JsonKey(name: 'childId') required String childId,
    @JsonKey(name: 'fullName') String? fullName,
    @JsonKey(name: 'gestationWeeks') int? gestationWeeks,
    @JsonKey(name: 'showBirthTimeToRelatives')
    @Default(false)
    bool showBirthTimeToRelatives,
    @JsonKey(name: 'nameStory') String? nameStory,
    @JsonKey(name: 'nameGivenBy') @Default([]) List<String> nameGivenBy,
    @JsonKey(name: 'favoriteFood') String? favoriteFood,
    @JsonKey(name: 'favoriteToy') String? favoriteToy,
    @JsonKey(name: 'favoriteSong') String? favoriteSong,
    @JsonKey(name: 'memoryCount') @Default(0) int memoryCount,
    @JsonKey(name: 'milestoneCount') @Default(0) int milestoneCount,
    @JsonKey(name: 'letterCount') @Default(0) int letterCount,
    @JsonKey(name: 'privateMemoryCount') @Default(0) int privateMemoryCount,
    @JsonKey(name: 'relativeViewerNames')
    @Default([])
    List<String> relativeViewerNames,

    /// CHD-05.
    @JsonKey(name: 'addedByUserId') String? addedByUserId,
    @JsonKey(name: 'addedAt') DateTime? addedAt,
    @JsonKey(name: 'duplicateOfChildId') String? duplicateOfChildId,
    @JsonKey(name: 'sharedMemoryCount') @Default(0) int sharedMemoryCount,
    @JsonKey(name: 'sharedWithChildIds')
    @Default([])
    List<String> sharedWithChildIds,
  }) = _ChildProfile;

  factory ChildProfile.fromJson(Map<String, dynamic> json) =>
      _$ChildProfileFromJson(json);
}
