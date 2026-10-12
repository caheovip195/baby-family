import 'package:baby_family/data/model/memory/memory.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_recap.freezed.dart';
part 'weekly_recap.g.dart';

/// REC-02 “Tuần của nhà mình”.
@Freezed(when: FreezedWhenOptions.none)
abstract class WeeklyRecap with _$WeeklyRecap {
  @JsonSerializable(explicitToJson: true)
  const factory WeeklyRecap({
    @JsonKey(name: 'start') required DateTime start,
    @JsonKey(name: 'end') required DateTime end,
    @JsonKey(name: 'headline') @Default('') String headline,
    @JsonKey(name: 'moments') @Default(0) int moments,
    @JsonKey(name: 'firsts') @Default(0) int firsts,
    @JsonKey(name: 'quotes') @Default(0) int quotes,
    @JsonKey(name: 'heroAssets') @Default([]) List<String> heroAssets,
    @JsonKey(name: 'highlights') @Default([]) List<Memory> highlights,
    @JsonKey(name: 'togetherTitle') String? togetherTitle,
    @JsonKey(name: 'togetherBody') String? togetherBody,
    @JsonKey(name: 'pageCount') @Default(1) int pageCount,
  }) = _WeeklyRecap;

  factory WeeklyRecap.fromJson(Map<String, dynamic> json) =>
      _$WeeklyRecapFromJson(json);
}
