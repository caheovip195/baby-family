import 'package:baby_family/data/model/care/mission_history_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_history_day.freezed.dart';
part 'mission_history_day.g.dart';

/// Một ngày trong lịch sử nhiệm vụ (CARE-08).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionHistoryDay with _$MissionHistoryDay {
  @JsonSerializable(explicitToJson: true)
  const factory MissionHistoryDay({
    @JsonKey(name: 'date') required DateTime date,
    @JsonKey(name: 'entries') @Default([]) List<MissionHistoryEntry> entries,
  }) = _MissionHistoryDay;

  factory MissionHistoryDay.fromJson(Map<String, dynamic> json) =>
      _$MissionHistoryDayFromJson(json);
}
