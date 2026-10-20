import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_progress_record.freezed.dart';
part 'badge_progress_record.g.dart';

/// Tiến độ một huy hiệu chưa đạt.
@Freezed(when: FreezedWhenOptions.none)
abstract class BadgeProgressRecord with _$BadgeProgressRecord {
  @JsonSerializable(explicitToJson: true)
  const factory BadgeProgressRecord({
    @JsonKey(name: 'current') @Default(0) int current,
    @JsonKey(name: 'target') @Default(0) int target,
    @JsonKey(name: 'percent') @Default(0) int percent,
  }) = _BadgeProgressRecord;

  factory BadgeProgressRecord.fromJson(Map<String, dynamic> json) =>
      _$BadgeProgressRecordFromJson(json);
}
