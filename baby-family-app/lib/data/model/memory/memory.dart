import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory.freezed.dart';
part 'memory.g.dart';

/// Ký ức (mục 7.5–7.11). Chữ người dùng nhập giữ nguyên; `milestoneTitle` là catalog đã dịch.
@Freezed(when: FreezedWhenOptions.none)
abstract class Memory with _$Memory {
  @JsonSerializable(explicitToJson: true)
  const factory Memory({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'familyId') required String familyId,
    @JsonKey(name: 'kind') required MemoryKind kind,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'body') String? body,
    @JsonKey(name: 'quoteContext') String? quoteContext,
    @JsonKey(name: 'childIds') @Default([]) List<String> childIds,
    @JsonKey(name: 'authorId') required String authorId,
    @JsonKey(name: 'occurredAt') required DateTime occurredAt,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'mediaAssets') @Default([]) List<String> mediaAssets,
    @JsonKey(name: 'visibility')
    @Default(MemoryVisibility.family)
    MemoryVisibility visibility,
    @JsonKey(name: 'feeling') String? feeling,
    @JsonKey(name: 'people') @Default([]) List<String> people,
    @JsonKey(name: 'milestoneCode') String? milestoneCode,
    @JsonKey(name: 'milestoneTitle') String? milestoneTitle,
    @JsonKey(name: 'monthIndex') int? monthIndex,
    @JsonKey(name: 'pregnancyWeek') int? pregnancyWeek,
    @JsonKey(name: 'pregnancyDay') int? pregnancyDay,
    @JsonKey(name: 'voiceDurationSec') int? voiceDurationSec,
    @JsonKey(name: 'sealedUntil') DateTime? sealedUntil,
    @JsonKey(name: 'missionId') String? missionId,
    @JsonKey(name: 'reactions') @Default({}) Map<String, int> reactions,
    @JsonKey(name: 'reactorNames') @Default([]) List<String> reactorNames,
    @JsonKey(name: 'commentCount') @Default(0) int commentCount,
    @JsonKey(name: 'perspectiveCount') @Default(0) int perspectiveCount,
    @JsonKey(name: 'perspectiveAuthorId') String? perspectiveAuthorId,
    @JsonKey(name: 'perspectivePreview') String? perspectivePreview,
    @JsonKey(name: 'isFavorite') @Default(false) bool isFavorite,
    @JsonKey(name: 'pinned') @Default(false) bool pinned,
  }) = _Memory;

  const Memory._();

  factory Memory.fromJson(Map<String, dynamic> json) => _$MemoryFromJson(json);

  /// “Cả hai cùng kể”: bạn đời đã thêm góc nhìn thứ hai (MEM-24).
  bool get bothTell => perspectiveCount > 0;

  int get reactionTotal =>
      reactions.values.fold(0, (sum, count) => sum + count);
}
