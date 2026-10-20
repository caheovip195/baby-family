import 'package:baby_family/data/model/care/badge_progress_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_record.freezed.dart';
part 'badge_record.g.dart';

/// Huy hiệu của gia đình (`GET …/badges`, CARE-10).
@Freezed(when: FreezedWhenOptions.none)
abstract class BadgeRecord with _$BadgeRecord {
  @JsonSerializable(explicitToJson: true)
  const factory BadgeRecord({
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'titleI18n')
    @Default(<String, String>{})
    Map<String, String> titleI18n,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'descI18n')
    @Default(<String, String>{})
    Map<String, String> descI18n,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'earned') @Default(false) bool earned,
    @JsonKey(name: 'achievedAt') DateTime? achievedAt,
    @JsonKey(name: 'progress') BadgeProgressRecord? progress,
  }) = _BadgeRecord;

  factory BadgeRecord.fromJson(Map<String, dynamic> json) =>
      _$BadgeRecordFromJson(json);
}
