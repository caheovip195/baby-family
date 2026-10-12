import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_draft_item.freezed.dart';
part 'memory_draft_item.g.dart';

/// Ký ức đang soạn dở (MEM-18).
@Freezed(when: FreezedWhenOptions.none)
abstract class MemoryDraftItem with _$MemoryDraftItem {
  @JsonSerializable(explicitToJson: true)
  const factory MemoryDraftItem({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'kind') @Default(MemoryKind.photo) MemoryKind kind,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'childIds') @Default([]) List<String> childIds,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
    @JsonKey(name: 'location')
    @Default(DraftLocation.device)
    DraftLocation location,
    @JsonKey(name: 'deviceName') String? deviceName,
    @JsonKey(name: 'mediaAssets') @Default([]) List<String> mediaAssets,
    @JsonKey(name: 'extraCount') @Default(0) int extraCount,
    @JsonKey(name: 'voiceDurationSec') int? voiceDurationSec,
  }) = _MemoryDraftItem;

  factory MemoryDraftItem.fromJson(Map<String, dynamic> json) =>
      _$MemoryDraftItemFromJson(json);
}
