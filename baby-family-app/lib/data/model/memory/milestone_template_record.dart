import 'package:baby_family/data/model/memory/milestone_achieved_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone_template_record.freezed.dart';
part 'milestone_template_record.g.dart';

/// Mẫu cột mốc từ catalog server (MEM-11).
@Freezed(when: FreezedWhenOptions.none)
abstract class MilestoneTemplateRecord with _$MilestoneTemplateRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MilestoneTemplateRecord({
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'suggestedDate') DateTime? suggestedDate,
    @JsonKey(name: 'achieved') MilestoneAchievedRecord? achieved,
  }) = _MilestoneTemplateRecord;

  factory MilestoneTemplateRecord.fromJson(Map<String, dynamic> json) =>
      _$MilestoneTemplateRecordFromJson(json);
}
