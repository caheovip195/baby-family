import 'package:freezed_annotation/freezed_annotation.dart';

part 'display_settings_record.freezed.dart';
part 'display_settings_record.g.dart';

/// Phần hiển thị của `GET/PATCH /v1/me/settings` (SET-06): `theme`
/// SYSTEM | LIGHT | DARK, `textScale` 0.8…2, `showLunar`.
@Freezed(when: FreezedWhenOptions.none)
abstract class DisplaySettingsRecord with _$DisplaySettingsRecord {
  @JsonSerializable(explicitToJson: true)
  const factory DisplaySettingsRecord({
    @JsonKey(name: 'theme') String? theme,
    @JsonKey(name: 'textScale') double? textScale,
    @JsonKey(name: 'showLunar') bool? showLunar,
  }) = _DisplaySettingsRecord;

  factory DisplaySettingsRecord.fromJson(Map<String, dynamic> json) =>
      _$DisplaySettingsRecordFromJson(json);
}
