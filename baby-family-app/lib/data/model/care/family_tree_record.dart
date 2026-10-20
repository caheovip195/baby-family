import 'package:baby_family/data/model/care/family_tree_today_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_tree_record.freezed.dart';
part 'family_tree_record.g.dart';

/// Cây gia đình (`GET …/family-tree`): chỉ cấp + % — không có số Hearts.
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilyTreeRecord with _$FamilyTreeRecord {
  @JsonSerializable(explicitToJson: true)
  const factory FamilyTreeRecord({
    @JsonKey(name: 'level') @Default(1) int level,
    @JsonKey(name: 'levelName') String? levelName,
    @JsonKey(name: 'progressPercent') @Default(0) int progressPercent,
    @JsonKey(name: 'fruits') @Default(0) int fruits,
    @JsonKey(name: 'flowers') @Default(0) int flowers,
    @JsonKey(name: 'bloomedDaysThisWeek') @Default(0) int bloomedDaysThisWeek,
    @JsonKey(name: 'today') FamilyTreeTodayRecord? today,
  }) = _FamilyTreeRecord;

  factory FamilyTreeRecord.fromJson(Map<String, dynamic> json) =>
      _$FamilyTreeRecordFromJson(json);
}
