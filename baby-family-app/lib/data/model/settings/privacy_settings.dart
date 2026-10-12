import 'package:baby_family/data/model/settings/child_audience.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_settings.freezed.dart';
part 'privacy_settings.g.dart';

/// Quyền riêng tư (SET-04).
@Freezed(when: FreezedWhenOptions.none)
abstract class PrivacySettings with _$PrivacySettings {
  @JsonSerializable(explicitToJson: true)
  const factory PrivacySettings({
    @JsonKey(name: 'defaultVisibility')
    @Default(MemoryVisibility.family)
    MemoryVisibility defaultVisibility,
    @JsonKey(name: 'audiences') @Default([]) List<ChildAudience> audiences,
    @JsonKey(name: 'downloadAllowed') @Default([]) List<String> downloadAllowed,
    @JsonKey(name: 'postAllowed') @Default([]) List<String> postAllowed,
    @JsonKey(name: 'familyVisibleMemories')
    @Default(0)
    int familyVisibleMemories,
    @JsonKey(name: 'deviceCount') @Default(0) int deviceCount,
    @JsonKey(name: 'aiFeatures') @Default(0) int aiFeatures,
    @JsonKey(name: 'blockedCount') @Default(0) int blockedCount,
  }) = _PrivacySettings;

  factory PrivacySettings.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsFromJson(json);
}
