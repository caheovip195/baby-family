import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_story_record.freezed.dart';
part 'today_story_record.g.dart';

/// `GET /v1/children/{id}/today-story` (MEM-25): ảnh/video trong ngày của bé.
@Freezed(when: FreezedWhenOptions.none)
abstract class TodayStoryRecord with _$TodayStoryRecord {
  @JsonSerializable(explicitToJson: true)
  const factory TodayStoryRecord({
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'memoryCount') @Default(0) int memoryCount,
    @JsonKey(name: 'slides')
    @Default(<TodayStorySlideRecord>[])
    List<TodayStorySlideRecord> slides,
  }) = _TodayStoryRecord;

  factory TodayStoryRecord.fromJson(Map<String, dynamic> json) =>
      _$TodayStoryRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class TodayStorySlideRecord with _$TodayStorySlideRecord {
  @JsonSerializable(explicitToJson: true)
  const factory TodayStorySlideRecord({
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'videoUrl') String? videoUrl,
    @JsonKey(name: 'caption') String? caption,
    @JsonKey(name: 'occurredAt') DateTime? occurredAt,
  }) = _TodayStorySlideRecord;

  factory TodayStorySlideRecord.fromJson(Map<String, dynamic> json) =>
      _$TodayStorySlideRecordFromJson(json);
}
