import 'package:baby_family/data/model/care/mission_category_setting.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_settings.freezed.dart';
part 'mission_settings.g.dart';

/// Cài đặt nhiệm vụ (CARE-12).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionSettings with _$MissionSettings {
  @JsonSerializable(explicitToJson: true)
  const factory MissionSettings({
    @JsonKey(name: 'level')
    @Default(MissionLoadLevel.medium)
    MissionLoadLevel level,
    @JsonKey(name: 'categories')
    @Default([])
    List<MissionCategorySetting> categories,
    @JsonKey(name: 'boardTime') @Default('07:00') String boardTime,
    @JsonKey(name: 'askAtNight') @Default(true) bool askAtNight,
    @JsonKey(name: 'defaultReminder')
    @Default(MissionReminder.before15)
    MissionReminder defaultReminder,
  }) = _MissionSettings;

  factory MissionSettings.fromJson(Map<String, dynamic> json) =>
      _$MissionSettingsFromJson(json);
}
