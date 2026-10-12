import 'package:baby_family/data/model/memory/memory.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'month_recap.freezed.dart';
part 'month_recap.g.dart';

/// REC-03 “Tháng tuổi” — tổng kết tháng thứ `monthIndex` của bé.
@Freezed(when: FreezedWhenOptions.none)
abstract class MonthRecap with _$MonthRecap {
  @JsonSerializable(explicitToJson: true)
  const factory MonthRecap({
    @JsonKey(name: 'childId') required String childId,
    @JsonKey(name: 'monthIndex') required int monthIndex,
    @JsonKey(name: 'start') required DateTime start,
    @JsonKey(name: 'end') required DateTime end,
    @JsonKey(name: 'headline') @Default('') String headline,
    @JsonKey(name: 'moments') @Default(0) int moments,
    @JsonKey(name: 'firsts') @Default(0) int firsts,
    @JsonKey(name: 'voices') @Default(0) int voices,
    @JsonKey(name: 'previousPhotoAsset') String? previousPhotoAsset,
    @JsonKey(name: 'currentPhotoAsset') String? currentPhotoAsset,
    @JsonKey(name: 'firstMemories') @Default([]) List<Memory> firstMemories,
    @JsonKey(name: 'voiceMemories') @Default([]) List<Memory> voiceMemories,
    @JsonKey(name: 'pageCount') @Default(1) int pageCount,
  }) = _MonthRecap;

  factory MonthRecap.fromJson(Map<String, dynamic> json) =>
      _$MonthRecapFromJson(json);
}
