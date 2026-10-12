import 'package:baby_family/data/model/settings/sign_in_method.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_settings.freezed.dart';
part 'profile_settings.g.dart';

/// Hồ sơ của tôi (SET-02).
@Freezed(when: FreezedWhenOptions.none)
abstract class ProfileSettings with _$ProfileSettings {
  @JsonSerializable(explicitToJson: true)
  const factory ProfileSettings({
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'callName') @Default('') String callName,
    @JsonKey(name: 'avatarAsset') String? avatarAsset,
    @JsonKey(name: 'signInMethods')
    @Default([])
    List<SignInMethod> signInMethods,
    @JsonKey(name: 'autoTimezone') @Default(true) bool autoTimezone,
    @JsonKey(name: 'timezoneLabel') @Default('') String timezoneLabel,
  }) = _ProfileSettings;

  factory ProfileSettings.fromJson(Map<String, dynamic> json) =>
      _$ProfileSettingsFromJson(json);
}
