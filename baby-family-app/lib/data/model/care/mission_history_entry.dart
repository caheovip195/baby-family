import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_history_entry.freezed.dart';
part 'mission_history_entry.g.dart';

/// Một dòng trong lịch sử nhiệm vụ (CARE-08). `hearts` chỉ có với việc của tôi/cùng nhau.
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionHistoryEntry with _$MissionHistoryEntry {
  @JsonSerializable(explicitToJson: true)
  const factory MissionHistoryEntry({
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'ownerKind')
    @Default(MissionOwnerKind.me)
    MissionOwnerKind ownerKind,
    @JsonKey(name: 'done') @Default(true) bool done,
    @JsonKey(name: 'completedTime') String? completedTime,
    @JsonKey(name: 'categoryCode') String? categoryCode,
    @JsonKey(name: 'hearts') int? hearts,
    @JsonKey(name: 'childIds') @Default([]) List<String> childIds,
    @JsonKey(name: 'couple') @Default(false) bool couple,
  }) = _MissionHistoryEntry;

  factory MissionHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$MissionHistoryEntryFromJson(json);
}
