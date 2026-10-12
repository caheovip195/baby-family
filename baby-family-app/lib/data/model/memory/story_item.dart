import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_item.freezed.dart';
part 'story_item.g.dart';

/// Ảnh trong story “Hôm nay của bé” (MEM-25, HOME-01 stories).
@Freezed(when: FreezedWhenOptions.none)
abstract class StoryItem with _$StoryItem {
  @JsonSerializable(explicitToJson: true)
  const factory StoryItem({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'childId') required String childId,
    @JsonKey(name: 'asset') required String asset,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'caption') String? caption,
    @JsonKey(name: 'authorId') required String authorId,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'seen') @Default(false) bool seen,
  }) = _StoryItem;

  factory StoryItem.fromJson(Map<String, dynamic> json) =>
      _$StoryItemFromJson(json);
}
