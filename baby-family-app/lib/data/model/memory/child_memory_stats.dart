import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_memory_stats.freezed.dart';
part 'child_memory_stats.g.dart';

/// Số đếm ký ức của bé (MEM-01, HOME-02).
@Freezed(when: FreezedWhenOptions.none)
abstract class ChildMemoryStats with _$ChildMemoryStats {
  @JsonSerializable(explicitToJson: true)
  const factory ChildMemoryStats({
    @JsonKey(name: 'childId') required String childId,
    @JsonKey(name: 'memories') @Default(0) int memories,
    @JsonKey(name: 'firsts') @Default(0) int firsts,
    @JsonKey(name: 'voices') @Default(0) int voices,
    @JsonKey(name: 'quotes') @Default(0) int quotes,
  }) = _ChildMemoryStats;

  factory ChildMemoryStats.fromJson(Map<String, dynamic> json) =>
      _$ChildMemoryStatsFromJson(json);
}
