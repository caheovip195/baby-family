import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings_record.freezed.dart';
part 'notification_settings_record.g.dart';

/// `GET/PATCH /v1/me/notification-settings` — nhóm thông báo theo catalog
/// server (MEMORIES, REQUESTS, US, APPRECIATION, PROMOTIONS…).
@Freezed(when: FreezedWhenOptions.none)
abstract class NotificationSettingsRecord with _$NotificationSettingsRecord {
  @JsonSerializable(explicitToJson: true)
  const factory NotificationSettingsRecord({
    @JsonKey(name: 'quietStart') String? quietStart,
    @JsonKey(name: 'quietEnd') String? quietEnd,
    @JsonKey(name: 'hideSensitivePreview') bool? hideSensitivePreview,
    @JsonKey(name: 'categories')
    @Default(<String, bool>{})
    Map<String, bool> categories,
    @JsonKey(name: 'circleDigestMode') String? circleDigestMode,
    @JsonKey(name: 'circleDigestTime') String? circleDigestTime,
  }) = _NotificationSettingsRecord;

  factory NotificationSettingsRecord.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsRecordFromJson(json);
}
