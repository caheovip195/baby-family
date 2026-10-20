import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_preferences_record.freezed.dart';
part 'mission_preferences_record.g.dart';

/// Tuỳ chọn nhiệm vụ của CHÍNH người gọi (CARE-12).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionPreferencesRecord with _$MissionPreferencesRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MissionPreferencesRecord({
    @JsonKey(name: 'disabledCategories')
    @Default(<String>[])
    List<String> disabledCategories,
    @JsonKey(name: 'boardPushTime') String? boardPushTime,
    @JsonKey(name: 'eveningCarryOver') @Default(true) bool eveningCarryOver,
    @JsonKey(name: 'defaultReminderMin') int? defaultReminderMin,
  }) = _MissionPreferencesRecord;

  factory MissionPreferencesRecord.fromJson(Map<String, dynamic> json) =>
      _$MissionPreferencesRecordFromJson(json);
}
