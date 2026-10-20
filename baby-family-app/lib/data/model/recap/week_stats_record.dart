import 'package:freezed_annotation/freezed_annotation.dart';

part 'week_stats_record.freezed.dart';
part 'week_stats_record.g.dart';

/// Số liệu một tuần theo quyền xem (`GET /v1/families/{fid}/home/week-stats`,
/// cũng là `content.stats` của recap tuần).
@Freezed(when: FreezedWhenOptions.none)
abstract class WeekStatsRecord with _$WeekStatsRecord {
  @JsonSerializable(explicitToJson: true)
  const factory WeekStatsRecord({
    @JsonKey(name: 'weekStart') String? weekStart,
    @JsonKey(name: 'memoryCount') @Default(0) int memoryCount,
    @JsonKey(name: 'photoCount') @Default(0) int photoCount,
    @JsonKey(name: 'videoCount') @Default(0) int videoCount,
    @JsonKey(name: 'milestoneCount') @Default(0) int milestoneCount,
    @JsonKey(name: 'missionsDone') int? missionsDone,
  }) = _WeekStatsRecord;

  factory WeekStatsRecord.fromJson(Map<String, dynamic> json) =>
      _$WeekStatsRecordFromJson(json);
}
