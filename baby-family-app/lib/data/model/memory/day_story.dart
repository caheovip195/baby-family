import 'package:baby_family/data/model/memory/day_story_item.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_story.freezed.dart';
part 'day_story.g.dart';

/// REC-01 “Câu chuyện ngày” (AI viết, bạn sửa).
@Freezed(when: FreezedWhenOptions.none)
abstract class DayStory with _$DayStory {
  @JsonSerializable(explicitToJson: true)
  const factory DayStory({
    @JsonKey(name: 'date') required DateTime date,
    @JsonKey(name: 'childId') required String childId,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'body') @Default('') String body,
    @JsonKey(name: 'aiGenerated') @Default(true) bool aiGenerated,
    @JsonKey(name: 'items') @Default([]) List<DayStoryItem> items,
    @JsonKey(name: 'photoAssets') @Default([]) List<String> photoAssets,

    /// REC-01 “Ảnh kèm”: mọi ảnh trong ngày có thể kèm; [photoAssets] là các
    /// ảnh đang chọn.
    @JsonKey(name: 'photoOptions') @Default([]) List<String> photoOptions,
    @JsonKey(name: 'coverAsset') String? coverAsset,
    @JsonKey(name: 'visibility')
    @Default(MemoryVisibility.parents)
    MemoryVisibility visibility,
  }) = _DayStory;

  factory DayStory.fromJson(Map<String, dynamic> json) =>
      _$DayStoryFromJson(json);
}
