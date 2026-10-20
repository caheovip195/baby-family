import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_reminder_rule_record.freezed.dart';
part 'event_reminder_rule_record.g.dart';

/// Quy tắc nhắc của sự kiện: nhắc ai, trước bao nhiêu phút (CAL-02).
@Freezed(when: FreezedWhenOptions.none)
abstract class EventReminderRuleRecord with _$EventReminderRuleRecord {
  @JsonSerializable(explicitToJson: true)
  const factory EventReminderRuleRecord({
    @JsonKey(name: 'recipientUserId') String? recipientUserId,
    @JsonKey(name: 'offsetMinutes') int? offsetMinutes,
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
  }) = _EventReminderRuleRecord;

  factory EventReminderRuleRecord.fromJson(Map<String, dynamic> json) =>
      _$EventReminderRuleRecordFromJson(json);
}
