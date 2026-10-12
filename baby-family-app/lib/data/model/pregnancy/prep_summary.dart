import 'package:baby_family/data/model/pregnancy/prep_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prep_summary.freezed.dart';
part 'prep_summary.g.dart';

/// Tiến độ chuẩn bị (PREG-04, HOME-03 “12/30”).
@Freezed(when: FreezedWhenOptions.none)
abstract class PrepSummary with _$PrepSummary {
  @JsonSerializable(explicitToJson: true)
  const factory PrepSummary({
    @JsonKey(name: 'done') @Default(0) int done,
    @JsonKey(name: 'total') @Default(0) int total,
    @JsonKey(name: 'items') @Default([]) List<PrepItem> items,
  }) = _PrepSummary;

  factory PrepSummary.fromJson(Map<String, dynamic> json) =>
      _$PrepSummaryFromJson(json);
}
