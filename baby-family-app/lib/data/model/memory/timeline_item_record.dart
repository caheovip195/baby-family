import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline_item_record.freezed.dart';
part 'timeline_item_record.g.dart';

/// Một mục của `GET /v1/families/{fid}/timeline`: ký ức (`type = MEMORY`) hoặc thẻ hệ thống (`SYSTEM`: chào đời, tròn tháng).
@Freezed(when: FreezedWhenOptions.none)
abstract class TimelineItemRecord with _$TimelineItemRecord {
  @JsonSerializable(explicitToJson: true)
  const factory TimelineItemRecord({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'memory') MemoryRecord? memory,
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'monthIndex') int? monthIndex,
    @JsonKey(name: 'date') String? date,

    /// Thẻ `CHAPTER` (BF-20261019-008): ảnh tháng làm bìa + số liệu tháng.
    @JsonKey(name: 'coverUrl') String? coverUrl,
    @JsonKey(name: 'memoryCount') int? memoryCount,
    @JsonKey(name: 'firstsCount') int? firstsCount,
  }) = _TimelineItemRecord;

  factory TimelineItemRecord.fromJson(Map<String, dynamic> json) =>
      _$TimelineItemRecordFromJson(json);
}
