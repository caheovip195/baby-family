import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_count.freezed.dart';
part 'category_count.g.dart';

/// Số việc theo nhóm trong tuần (CARE-11).
@Freezed(when: FreezedWhenOptions.none)
abstract class CategoryCount with _$CategoryCount {
  @JsonSerializable(explicitToJson: true)
  const factory CategoryCount({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'count') @Default(0) int count,
  }) = _CategoryCount;

  factory CategoryCount.fromJson(Map<String, dynamic> json) =>
      _$CategoryCountFromJson(json);
}
