import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_channel_setting.freezed.dart';
part 'notification_channel_setting.g.dart';

/// Một nhóm thông báo (SET-03); tiêu đề/gợi ý là catalog đã dịch.
@Freezed(when: FreezedWhenOptions.none)
abstract class NotificationChannelSetting with _$NotificationChannelSetting {
  @JsonSerializable(explicitToJson: true)
  const factory NotificationChannelSetting({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'hint') String? hint,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
  }) = _NotificationChannelSetting;

  factory NotificationChannelSetting.fromJson(Map<String, dynamic> json) =>
      _$NotificationChannelSettingFromJson(json);
}
