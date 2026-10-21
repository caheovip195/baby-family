import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_settings.freezed.dart';
part 'family_settings.g.dart';

/// Cài đặt gia đình (FAM-07).
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilySettings with _$FamilySettings {
  @JsonSerializable(explicitToJson: true)
  const factory FamilySettings({
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'coverAsset') String? coverAsset,
    @JsonKey(name: 'defaultVisibility')
    @Default(MemoryVisibility.family)
    MemoryVisibility defaultVisibility,
    @JsonKey(name: 'approveRelativePhotos')
    @Default(true)
    bool approveRelativePhotos,
    @JsonKey(name: 'relativesSeeTree') @Default(true) bool relativesSeeTree,
    @JsonKey(name: 'milestoneSuggestions')
    @Default(true)
    bool milestoneSuggestions,
    @JsonKey(name: 'timezoneLabel') @Default('') String timezoneLabel,

    /// Múi giờ IANA của gia đình (bản server); null ở bản mẫu.
    @JsonKey(name: 'timezoneId') String? timezoneId,
    @JsonKey(name: 'showLunar') @Default(true) bool showLunar,
    @JsonKey(name: 'milestonesByLunar') @Default(true) bool milestonesByLunar,
    @JsonKey(name: 'contentLanguage') @Default('vi') String contentLanguage,
  }) = _FamilySettings;

  factory FamilySettings.fromJson(Map<String, dynamic> json) =>
      _$FamilySettingsFromJson(json);
}
