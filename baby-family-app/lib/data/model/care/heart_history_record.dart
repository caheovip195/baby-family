import 'package:freezed_annotation/freezed_annotation.dart';

part 'heart_history_record.freezed.dart';
part 'heart_history_record.g.dart';

/// Một dòng sổ Hearts của chính tôi (`GET …/hearts/me`).
@Freezed(when: FreezedWhenOptions.none)
abstract class HeartHistoryRecord with _$HeartHistoryRecord {
  @JsonSerializable(explicitToJson: true)
  const factory HeartHistoryRecord({
    @JsonKey(name: 'at') DateTime? at,
    @JsonKey(name: 'amount') @Default(0) int amount,
    @JsonKey(name: 'reason') String? reason,
    @JsonKey(name: 'title') String? title,
  }) = _HeartHistoryRecord;

  factory HeartHistoryRecord.fromJson(Map<String, dynamic> json) =>
      _$HeartHistoryRecordFromJson(json);
}
