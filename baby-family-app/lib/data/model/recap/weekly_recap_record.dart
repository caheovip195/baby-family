import 'package:baby_family/data/model/recap/week_stats_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_recap_record.freezed.dart';
part 'weekly_recap_record.g.dart';

/// REC-02 recap tuần của server (`/recaps/weekly/latest`); `content` có
/// version, ký ức nổi bật chỉ là id.
@Freezed(when: FreezedWhenOptions.none)
abstract class WeeklyRecapRecord with _$WeeklyRecapRecord {
  @JsonSerializable(explicitToJson: true)
  const factory WeeklyRecapRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'periodStart') String? periodStart,
    @JsonKey(name: 'periodEnd') String? periodEnd,
    @JsonKey(name: 'visibility') String? visibility,
    @JsonKey(name: 'content') WeeklyRecapContent? content,
  }) = _WeeklyRecapRecord;

  factory WeeklyRecapRecord.fromJson(Map<String, dynamic> json) =>
      _$WeeklyRecapRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class WeeklyRecapContent with _$WeeklyRecapContent {
  @JsonSerializable(explicitToJson: true)
  const factory WeeklyRecapContent({
    @JsonKey(name: 'version') int? version,
    @JsonKey(name: 'stats') WeekStatsRecord? stats,
    @JsonKey(name: 'topMemories')
    @Default(<RecapMemoryRef>[])
    List<RecapMemoryRef> topMemories,
  }) = _WeeklyRecapContent;

  factory WeeklyRecapContent.fromJson(Map<String, dynamic> json) =>
      _$WeeklyRecapContentFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class RecapMemoryRef with _$RecapMemoryRef {
  @JsonSerializable(explicitToJson: true)
  const factory RecapMemoryRef({@JsonKey(name: 'id') String? id}) =
      _RecapMemoryRef;

  factory RecapMemoryRef.fromJson(Map<String, dynamic> json) =>
      _$RecapMemoryRefFromJson(json);
}
