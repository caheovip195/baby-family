import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_story_item.freezed.dart';
part 'day_story_item.g.dart';

/// Một ký ức/hoạt động có thể đưa vào câu chuyện ngày (REC-01).
@Freezed(when: FreezedWhenOptions.none)
abstract class DayStoryItem with _$DayStoryItem {
  @JsonSerializable(explicitToJson: true)
  const factory DayStoryItem({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'kindCode') @Default('photo') String kindCode,
    @JsonKey(name: 'time') String? time,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'selected') @Default(true) bool selected,
  }) = _DayStoryItem;

  factory DayStoryItem.fromJson(Map<String, dynamic> json) =>
      _$DayStoryItemFromJson(json);
}
