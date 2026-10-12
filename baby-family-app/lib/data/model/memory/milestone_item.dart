import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone_item.freezed.dart';
part 'milestone_item.g.dart';

/// Cột mốc catalog + trạng thái đạt được (MEM-12, HOME-02/03).
@Freezed(when: FreezedWhenOptions.none)
abstract class MilestoneItem with _$MilestoneItem {
  @JsonSerializable(explicitToJson: true)
  const factory MilestoneItem({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'forPregnancy') @Default(false) bool forPregnancy,
    @JsonKey(name: 'typicalAgeDays') int? typicalAgeDays,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'achievedAt') DateTime? achievedAt,
    @JsonKey(name: 'asset') String? asset,
  }) = _MilestoneItem;

  const MilestoneItem._();

  factory MilestoneItem.fromJson(Map<String, dynamic> json) =>
      _$MilestoneItemFromJson(json);

  bool get achieved => memoryId != null;
}
