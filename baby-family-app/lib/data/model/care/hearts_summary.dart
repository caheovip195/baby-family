import 'package:baby_family/data/model/care/hearts_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hearts_summary.freezed.dart';
part 'hearts_summary.g.dart';

/// Hearts của người đang đăng nhập — chỉ người đó thấy (BR-018).
@Freezed(when: FreezedWhenOptions.none)
abstract class HeartsSummary with _$HeartsSummary {
  @JsonSerializable(explicitToJson: true)
  const factory HeartsSummary({
    @JsonKey(name: 'today') @Default(0) int today,
    @JsonKey(name: 'week') @Default(0) int week,
    @JsonKey(name: 'total') @Default(0) int total,
    @JsonKey(name: 'recent') @Default([]) List<HeartsEntry> recent,
  }) = _HeartsSummary;

  factory HeartsSummary.fromJson(Map<String, dynamic> json) =>
      _$HeartsSummaryFromJson(json);
}
