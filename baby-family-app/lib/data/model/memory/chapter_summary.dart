import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_summary.freezed.dart';
part 'chapter_summary.g.dart';

/// Chương theo tháng tuổi của bé (MEM-01).
@Freezed(when: FreezedWhenOptions.none)
abstract class ChapterSummary with _$ChapterSummary {
  @JsonSerializable(explicitToJson: true)
  const factory ChapterSummary({
    @JsonKey(name: 'childId') required String childId,
    @JsonKey(name: 'monthIndex') required int monthIndex,
    @JsonKey(name: 'start') required DateTime start,
    @JsonKey(name: 'end') required DateTime end,
    @JsonKey(name: 'memoryCount') @Default(0) int memoryCount,
    @JsonKey(name: 'firstsCount') @Default(0) int firstsCount,
    @JsonKey(name: 'voiceCount') @Default(0) int voiceCount,
    @JsonKey(name: 'hasMonthlyPhoto') @Default(false) bool hasMonthlyPhoto,
    @JsonKey(name: 'coverAsset') String? coverAsset,
    @JsonKey(name: 'current') @Default(false) bool current,
  }) = _ChapterSummary;

  factory ChapterSummary.fromJson(Map<String, dynamic> json) =>
      _$ChapterSummaryFromJson(json);
}
