import 'package:freezed_annotation/freezed_annotation.dart';

part 'month_recap_record.freezed.dart';
part 'month_recap_record.g.dart';

/// REC-03 (`GET /children/{id}/month-recap`, BF-20261027-003): số liệu tháng
/// tuổi theo quyền xem; ký ức / ảnh tháng trả theo id để app dùng bản đã có.
@Freezed(when: FreezedWhenOptions.none)
abstract class MonthRecapRecord with _$MonthRecapRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MonthRecapRecord({
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'monthIndex') int? monthIndex,
    @JsonKey(name: 'start') String? start,
    @JsonKey(name: 'end') String? end,
    @JsonKey(name: 'moments') @Default(0) int moments,
    @JsonKey(name: 'firsts') @Default(0) int firsts,
    @JsonKey(name: 'voices') @Default(0) int voices,
    @JsonKey(name: 'firstMemoryIds')
    @Default(<String>[])
    List<String> firstMemoryIds,
    @JsonKey(name: 'voiceMemoryIds')
    @Default(<String>[])
    List<String> voiceMemoryIds,
  }) = _MonthRecapRecord;

  factory MonthRecapRecord.fromJson(Map<String, dynamic> json) =>
      _$MonthRecapRecordFromJson(json);
}
