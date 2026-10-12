import 'package:baby_family/data/model/settings/login_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_settings.freezed.dart';
part 'security_settings.g.dart';

/// Bảo mật & thiết bị (SET-07).
@Freezed(when: FreezedWhenOptions.none)
abstract class SecuritySettings with _$SecuritySettings {
  @JsonSerializable(explicitToJson: true)
  const factory SecuritySettings({
    @JsonKey(name: 'faceIdLock') @Default(true) bool faceIdLock,
    @JsonKey(name: 'pinSet') @Default(true) bool pinSet,
    @JsonKey(name: 'devices') @Default([]) List<LoginDevice> devices,
  }) = _SecuritySettings;

  factory SecuritySettings.fromJson(Map<String, dynamic> json) =>
      _$SecuritySettingsFromJson(json);
}
