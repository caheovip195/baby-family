import 'package:baby_family/data/model/care/heart_history_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hearts_me_record.freezed.dart';
part 'hearts_me_record.g.dart';

/// Hearts của CHÍNH người gọi (BR-018, tài liệu kỹ thuật 6.6) — không có Hearts của bạn đời.
@Freezed(when: FreezedWhenOptions.none)
abstract class HeartsMeRecord with _$HeartsMeRecord {
  @JsonSerializable(explicitToJson: true)
  const factory HeartsMeRecord({
    @JsonKey(name: 'today') @Default(0) int today,
    @JsonKey(name: 'week') @Default(0) int week,
    @JsonKey(name: 'total') @Default(0) int total,
    @JsonKey(name: 'dailyCap') int? dailyCap,
    @JsonKey(name: 'history')
    @Default(<HeartHistoryRecord>[])
    List<HeartHistoryRecord> history,
  }) = _HeartsMeRecord;

  factory HeartsMeRecord.fromJson(Map<String, dynamic> json) =>
      _$HeartsMeRecordFromJson(json);
}
