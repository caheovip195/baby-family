import 'package:baby_family/data/model/care/category_count.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_stats.freezed.dart';
part 'care_stats.g.dart';

/// CARE-11 thống kê chăm con cả nhà (không chia theo người — BR-025).
@Freezed(when: FreezedWhenOptions.none)
abstract class CareStats with _$CareStats {
  @JsonSerializable(explicitToJson: true)
  const factory CareStats({
    @JsonKey(name: 'weekStart') required DateTime weekStart,
    @JsonKey(name: 'weekEnd') required DateTime weekEnd,
    @JsonKey(name: 'total') @Default(0) int total,
    @JsonKey(name: 'categories') @Default([]) List<CategoryCount> categories,
    @JsonKey(name: 'bloomDays') @Default(0) int bloomDays,
    @JsonKey(name: 'bloomed') @Default([]) List<bool> bloomed,
  }) = _CareStats;

  factory CareStats.fromJson(Map<String, dynamic> json) =>
      _$CareStatsFromJson(json);
}
