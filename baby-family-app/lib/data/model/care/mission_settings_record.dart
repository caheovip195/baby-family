import 'package:baby_family/data/model/care/mission_preferences_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_settings_record.freezed.dart';
part 'mission_settings_record.g.dart';

/// `GET /families/:fid/mission-settings` (CARE-12): mức bảng của cả nhà +
/// tuỳ chọn của tôi.
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionSettingsRecord with _$MissionSettingsRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MissionSettingsRecord({
    @JsonKey(name: 'boardLevel') String? boardLevel,
    @JsonKey(name: 'preferences') MissionPreferencesRecord? preferences,
  }) = _MissionSettingsRecord;

  factory MissionSettingsRecord.fromJson(Map<String, dynamic> json) =>
      _$MissionSettingsRecordFromJson(json);
}
