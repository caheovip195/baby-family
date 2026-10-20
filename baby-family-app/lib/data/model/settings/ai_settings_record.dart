import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_settings_record.freezed.dart';
part 'ai_settings_record.g.dart';

/// `GET/PATCH /v1/me/ai-settings`.
@Freezed(when: FreezedWhenOptions.none)
abstract class AiSettingsRecord with _$AiSettingsRecord {
  @JsonSerializable(explicitToJson: true)
  const factory AiSettingsRecord({
    @JsonKey(name: 'aiEnabled') bool? aiEnabled,
    @JsonKey(name: 'features')
    @Default(<String, bool>{})
    Map<String, bool> features,
  }) = _AiSettingsRecord;

  factory AiSettingsRecord.fromJson(Map<String, dynamic> json) =>
      _$AiSettingsRecordFromJson(json);
}
