import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_series_record.freezed.dart';
part 'mission_series_record.g.dart';

/// Chuỗi nhiệm vụ lặp lại tự thêm (mục 7.13.6); `status` ACTIVE | PAUSED…,
/// `pausedRanges` [{from, to}] (YYYY-MM-DD).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionSeriesRecord with _$MissionSeriesRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MissionSeriesRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'ownerKind') String? ownerKind,
    @JsonKey(name: 'mine') @Default(false) bool mine,
    @JsonKey(name: 'scheduledTime') String? scheduledTime,
    @JsonKey(name: 'startDate') String? startDate,
    @JsonKey(name: 'endDate') String? endDate,
    @JsonKey(name: 'days') @Default(<String>[]) List<String> days,
    @JsonKey(name: 'pausedRanges')
    @Default(<Map<String, dynamic>>[])
    List<Map<String, dynamic>> pausedRanges,
    @JsonKey(name: 'status') String? status,
  }) = _MissionSeriesRecord;

  factory MissionSeriesRecord.fromJson(Map<String, dynamic> json) =>
      _$MissionSeriesRecordFromJson(json);
}
