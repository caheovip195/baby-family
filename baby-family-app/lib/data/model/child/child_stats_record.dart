import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_stats_record.freezed.dart';
part 'child_stats_record.g.dart';

/// `GET /children/:id/profile-stats` (CHD-01) — chỉ đếm ký ức người gọi xem được.
@Freezed(when: FreezedWhenOptions.none)
abstract class ChildStatsRecord with _$ChildStatsRecord {
  @JsonSerializable(explicitToJson: true)
  const factory ChildStatsRecord({
    @JsonKey(name: 'memoryCount') @Default(0) int memoryCount,
    @JsonKey(name: 'milestoneCount') @Default(0) int milestoneCount,
    @JsonKey(name: 'photoCount') @Default(0) int photoCount,
    @JsonKey(name: 'firstMemoryAt') DateTime? firstMemoryAt,
  }) = _ChildStatsRecord;

  factory ChildStatsRecord.fromJson(Map<String, dynamic> json) =>
      _$ChildStatsRecordFromJson(json);
}
