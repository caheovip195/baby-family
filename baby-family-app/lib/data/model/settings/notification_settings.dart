import 'package:baby_family/data/model/settings/notification_channel_setting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

/// Cài đặt thông báo (SET-03).
@Freezed(when: FreezedWhenOptions.none)
abstract class NotificationSettings with _$NotificationSettings {
  @JsonSerializable(explicitToJson: true)
  const factory NotificationSettings({
    @JsonKey(name: 'channels')
    @Default([])
    List<NotificationChannelSetting> channels,
    @JsonKey(name: 'quietHours') @Default(true) bool quietHours,
    @JsonKey(name: 'quietFrom') @Default('22:00') String quietFrom,
    @JsonKey(name: 'quietTo') @Default('06:30') String quietTo,
    @JsonKey(name: 'urgentBypassQuiet') @Default(false) bool urgentBypassQuiet,
    @JsonKey(name: 'hideOnLockScreen') @Default(true) bool hideOnLockScreen,
    @JsonKey(name: 'relativesDigestTime')
    @Default('19:00')
    String relativesDigestTime,
    @JsonKey(name: 'mutedPeople') @Default(0) int mutedPeople,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}
