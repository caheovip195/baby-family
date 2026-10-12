import 'package:freezed_annotation/freezed_annotation.dart';

part 'couple_week_item.freezed.dart';
part 'couple_week_item.g.dart';

/// Một việc hai ta đã cùng làm (US-14).
@Freezed(when: FreezedWhenOptions.none)
abstract class CoupleWeekItem with _$CoupleWeekItem {
  @JsonSerializable(explicitToJson: true)
  const factory CoupleWeekItem({
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'date') required DateTime date,
  }) = _CoupleWeekItem;

  factory CoupleWeekItem.fromJson(Map<String, dynamic> json) =>
      _$CoupleWeekItemFromJson(json);
}
