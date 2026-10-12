import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'couple_settings.freezed.dart';
part 'couple_settings.g.dart';

/// Cài đặt Papa & Mama của riêng tôi (US-15).
@Freezed(when: FreezedWhenOptions.none)
abstract class CoupleSettings with _$CoupleSettings {
  @JsonSerializable(explicitToJson: true)
  const factory CoupleSettings({
    @JsonKey(name: 'checkinShareMode')
    @Default(CheckinShareMode.askEachTime)
    CheckinShareMode checkinShareMode,
    @JsonKey(name: 'hideOnLockScreen') @Default(true) bool hideOnLockScreen,
    @JsonKey(name: 'faceIdLock') @Default(false) bool faceIdLock,
    @JsonKey(name: 'urgentBypassQuiet') @Default(false) bool urgentBypassQuiet,
    @JsonKey(name: 'quietFrom') @Default('22:00') String quietFrom,
    @JsonKey(name: 'quietTo') @Default('06:30') String quietTo,
    @JsonKey(name: 'bridgeRetentionDays') @Default(30) int bridgeRetentionDays,
    @JsonKey(name: 'journalFaceIdLock') @Default(true) bool journalFaceIdLock,
  }) = _CoupleSettings;

  factory CoupleSettings.fromJson(Map<String, dynamic> json) =>
      _$CoupleSettingsFromJson(json);
}
