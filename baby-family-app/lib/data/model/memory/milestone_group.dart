import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone_group.freezed.dart';
part 'milestone_group.g.dart';

/// Nhóm cột mốc của MEM-11 (catalog đã dịch).
@Freezed(when: FreezedWhenOptions.none)
abstract class MilestoneGroup with _$MilestoneGroup {
  @JsonSerializable(explicitToJson: true)
  const factory MilestoneGroup({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'emoji') @Default('') String emoji,
    @JsonKey(name: 'title') required String title,
  }) = _MilestoneGroup;

  factory MilestoneGroup.fromJson(Map<String, dynamic> json) =>
      _$MilestoneGroupFromJson(json);
}
