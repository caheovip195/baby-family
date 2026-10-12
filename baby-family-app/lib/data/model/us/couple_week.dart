import 'package:baby_family/data/model/us/couple_week_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'couple_week.freezed.dart';
part 'couple_week.g.dart';

/// US-14 “Tuần của hai ta” — đếm việc làm cho nhau, không điểm số.
@Freezed(when: FreezedWhenOptions.none)
abstract class CoupleWeek with _$CoupleWeek {
  @JsonSerializable(explicitToJson: true)
  const factory CoupleWeek({
    @JsonKey(name: 'start') required DateTime start,
    @JsonKey(name: 'end') required DateTime end,
    @JsonKey(name: 'headline') @Default('') String headline,
    @JsonKey(name: 'checkins') @Default(0) int checkins,
    @JsonKey(name: 'requestsHelped') @Default(0) int requestsHelped,
    @JsonKey(name: 'thanks') @Default(0) int thanks,
    @JsonKey(name: 'togetherMissions') @Default(0) int togetherMissions,
    @JsonKey(name: 'highlightThanks') String? highlightThanks,
    @JsonKey(name: 'highlightByUserId') String? highlightByUserId,
    @JsonKey(name: 'highlightAt') DateTime? highlightAt,
    @JsonKey(name: 'together') @Default([]) List<CoupleWeekItem> together,
  }) = _CoupleWeek;

  factory CoupleWeek.fromJson(Map<String, dynamic> json) =>
      _$CoupleWeekFromJson(json);
}
