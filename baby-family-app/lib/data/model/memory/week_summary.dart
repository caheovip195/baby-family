import 'package:freezed_annotation/freezed_annotation.dart';

part 'week_summary.freezed.dart';
part 'week_summary.g.dart';

/// “Tuần này của nhà mình” (HOME-01).
@Freezed(when: FreezedWhenOptions.none)
abstract class WeekSummary with _$WeekSummary {
  @JsonSerializable(explicitToJson: true)
  const factory WeekSummary({
    @JsonKey(name: 'moments') @Default(0) int moments,
    @JsonKey(name: 'firsts') @Default(0) int firsts,
    @JsonKey(name: 'quotes') @Default(0) int quotes,
    @JsonKey(name: 'thumbnails') @Default([]) List<String> thumbnails,
  }) = _WeekSummary;

  factory WeekSummary.fromJson(Map<String, dynamic> json) =>
      _$WeekSummaryFromJson(json);
}
