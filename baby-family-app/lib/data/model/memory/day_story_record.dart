import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_story_record.freezed.dart';
part 'day_story_record.g.dart';

/// REC-01 (`GET /children/{id}/day-story`, BF-20261028-006): ký ức trong ngày
/// của bé (kèm asset ảnh) + câu chuyện đã lưu (nếu có).
@Freezed(when: FreezedWhenOptions.none)
abstract class DayStoryRecord with _$DayStoryRecord {
  @JsonSerializable(explicitToJson: true)
  const factory DayStoryRecord({
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'memories', fromJson: _dayMemories)
    @Default(<DayStoryMemoryRecord>[])
    List<DayStoryMemoryRecord> memories,
    @JsonKey(name: 'saved') SavedDayStoryRecord? saved,
  }) = _DayStoryRecord;

  factory DayStoryRecord.fromJson(Map<String, dynamic> json) =>
      _$DayStoryRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class DayStoryMemoryRecord with _$DayStoryMemoryRecord {
  @JsonSerializable(explicitToJson: true)
  const factory DayStoryMemoryRecord({
    @JsonKey(name: 'memoryId') required String memoryId,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'occurredAt') DateTime? occurredAt,
    @JsonKey(name: 'assetIds') @Default(<String>[]) List<String> assetIds,
  }) = _DayStoryMemoryRecord;

  factory DayStoryMemoryRecord.fromJson(Map<String, dynamic> json) =>
      _$DayStoryMemoryRecordFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class SavedDayStoryRecord with _$SavedDayStoryRecord {
  @JsonSerializable(explicitToJson: true)
  const factory SavedDayStoryRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'body') String? body,
    @JsonKey(name: 'coverAssetId') String? coverAssetId,
    @JsonKey(name: 'memoryIds') @Default(<String>[]) List<String> memoryIds,
    @JsonKey(name: 'assetIds') @Default(<String>[]) List<String> assetIds,
    @JsonKey(name: 'visibility') String? visibility,
  }) = _SavedDayStoryRecord;

  factory SavedDayStoryRecord.fromJson(Map<String, dynamic> json) =>
      _$SavedDayStoryRecordFromJson(json);
}

List<DayStoryMemoryRecord> _dayMemories(Object? json) =>
    lenientList(json, DayStoryMemoryRecord.fromJson, label: 'ký ức trong ngày');
