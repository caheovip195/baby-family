import 'package:baby_family/data/model/memory/memory.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_this_day_group.freezed.dart';
part 'on_this_day_group.g.dart';

/// MEM-16: ký ức cùng ngày của một năm trước.
@Freezed(when: FreezedWhenOptions.none)
abstract class OnThisDayGroup with _$OnThisDayGroup {
  @JsonSerializable(explicitToJson: true)
  const factory OnThisDayGroup({
    @JsonKey(name: 'yearsAgo') required int yearsAgo,
    @JsonKey(name: 'date') required DateTime date,
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'memories') @Default([]) List<Memory> memories,
  }) = _OnThisDayGroup;

  factory OnThisDayGroup.fromJson(Map<String, dynamic> json) =>
      _$OnThisDayGroupFromJson(json);
}
