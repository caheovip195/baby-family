import 'package:baby_family/data/model/memory/milestone_template_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone_category_record.freezed.dart';
part 'milestone_category_record.g.dart';

/// Một nhóm cột mốc.
@Freezed(when: FreezedWhenOptions.none)
abstract class MilestoneCategoryRecord with _$MilestoneCategoryRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MilestoneCategoryRecord({
    @JsonKey(name: 'category') String? category,
    @JsonKey(name: 'templates')
    @Default(<MilestoneTemplateRecord>[])
    List<MilestoneTemplateRecord> templates,
  }) = _MilestoneCategoryRecord;

  factory MilestoneCategoryRecord.fromJson(Map<String, dynamic> json) =>
      _$MilestoneCategoryRecordFromJson(json);
}
