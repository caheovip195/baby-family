import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_tree.freezed.dart';
part 'family_tree.g.dart';

/// Cây gia đình (CARE-09, mục 7.14.2): chỉ cấp + %, không lộ Hearts từng người.
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilyTree with _$FamilyTree {
  @JsonSerializable(explicitToJson: true)
  const factory FamilyTree({
    @JsonKey(name: 'level') @Default(1) int level,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'nextName') String? nextName,
    @JsonKey(name: 'nextReward') String? nextReward,
    @JsonKey(name: 'progressPercent') @Default(0) int progressPercent,
    @JsonKey(name: 'todayLeaves') @Default(0) int todayLeaves,
    @JsonKey(name: 'todayTotal') @Default(0) int todayTotal,
    @JsonKey(name: 'bloomed') @Default(false) bool bloomed,
    @JsonKey(name: 'weekCareMoments') @Default(0) int weekCareMoments,
    @JsonKey(name: 'weekTogether') @Default(0) int weekTogether,
    @JsonKey(name: 'weekBloomDays') @Default(0) int weekBloomDays,
  }) = _FamilyTree;

  factory FamilyTree.fromJson(Map<String, dynamic> json) =>
      _$FamilyTreeFromJson(json);
}
