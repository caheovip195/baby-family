import 'package:freezed_annotation/freezed_annotation.dart';

part 'us_settings_record.freezed.dart';
part 'us_settings_record.g.dart';

/// `GET/PATCH /me/us-settings` (US-15) — chỉ của chính tôi.
@Freezed(when: FreezedWhenOptions.none)
abstract class UsSettingsRecord with _$UsSettingsRecord {
  @JsonSerializable(explicitToJson: true)
  const factory UsSettingsRecord({
    @JsonKey(name: 'usLockEnabled') bool? usLockEnabled,
    @JsonKey(name: 'moodShareDefault') String? moodShareDefault,
    @JsonKey(name: 'requestSoonBypassQuiet') bool? requestSoonBypassQuiet,
    @JsonKey(name: 'hideSensitivePreview') bool? hideSensitivePreview,
  }) = _UsSettingsRecord;

  factory UsSettingsRecord.fromJson(Map<String, dynamic> json) =>
      _$UsSettingsRecordFromJson(json);
}
