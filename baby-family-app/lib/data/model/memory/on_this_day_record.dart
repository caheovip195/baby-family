import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_this_day_record.freezed.dart';
part 'on_this_day_record.g.dart';

/// `GET /v1/families/{fid}/on-this-day` (MEM-16).
@Freezed(when: FreezedWhenOptions.none)
abstract class OnThisDayRecord with _$OnThisDayRecord {
  @JsonSerializable(explicitToJson: true)
  const factory OnThisDayRecord({
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'groups')
    @Default(<OnThisDayGroupRecord>[])
    List<OnThisDayGroupRecord> groups,
  }) = _OnThisDayRecord;

  factory OnThisDayRecord.fromJson(Map<String, dynamic> json) =>
      _$OnThisDayRecordFromJson(json);
}

/// Ký ức cùng ngày của một năm trước.
@Freezed(when: FreezedWhenOptions.none)
abstract class OnThisDayGroupRecord with _$OnThisDayGroupRecord {
  @JsonSerializable(explicitToJson: true)
  const factory OnThisDayGroupRecord({
    @JsonKey(name: 'yearsAgo') @Default(0) int yearsAgo,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'memories')
    @Default(<MemoryRecord>[])
    List<MemoryRecord> memories,
  }) = _OnThisDayGroupRecord;

  factory OnThisDayGroupRecord.fromJson(Map<String, dynamic> json) =>
      _$OnThisDayGroupRecordFromJson(json);
}
