import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone_achieved_record.freezed.dart';
part 'milestone_achieved_record.g.dart';

/// Cột mốc đã ghi của bé.
@Freezed(when: FreezedWhenOptions.none)
abstract class MilestoneAchievedRecord with _$MilestoneAchievedRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MilestoneAchievedRecord({
    @JsonKey(name: 'milestoneId') String? milestoneId,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'occurredOn') DateTime? occurredOn,
  }) = _MilestoneAchievedRecord;

  factory MilestoneAchievedRecord.fromJson(Map<String, dynamic> json) =>
      _$MilestoneAchievedRecordFromJson(json);
}
