import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone_option.freezed.dart';
part 'milestone_option.g.dart';

/// Một cột mốc trong MEM-11: đã ghi (`recordedAt`) hoặc dự kiến (`expectedDate`).
@Freezed(when: FreezedWhenOptions.none)
abstract class MilestoneOption with _$MilestoneOption {
  @JsonSerializable(explicitToJson: true)
  const factory MilestoneOption({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'group') required String group,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'recordedAt') DateTime? recordedAt,
    @JsonKey(name: 'expectedDate') DateTime? expectedDate,
  }) = _MilestoneOption;

  const MilestoneOption._();

  factory MilestoneOption.fromJson(Map<String, dynamic> json) =>
      _$MilestoneOptionFromJson(json);

  bool get recorded => recordedAt != null;
}
