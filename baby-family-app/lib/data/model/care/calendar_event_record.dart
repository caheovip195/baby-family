import 'package:baby_family/data/model/care/event_participant_record.dart';
import 'package:baby_family/data/model/care/event_reminder_rule_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event_record.freezed.dart';
part 'calendar_event_record.g.dart';

/// Sự kiện từ server (`/events`, `/calendar`). Sự kiện lặp hằng năm có
/// `occurrenceDate` là ngày rơi vào khoảng đang xem.
@Freezed(when: FreezedWhenOptions.none)
abstract class CalendarEventRecord with _$CalendarEventRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CalendarEventRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'notes') String? notes,
    @JsonKey(name: 'allDay') @Default(false) bool allDay,
    @JsonKey(name: 'startAt') DateTime? startAt,
    @JsonKey(name: 'localStartDate') String? localStartDate,
    @JsonKey(name: 'occurrenceDate') String? occurrenceDate,
    @JsonKey(name: 'isLunar') @Default(false) bool isLunar,
    @JsonKey(name: 'lunarMonth') int? lunarMonth,
    @JsonKey(name: 'lunarDay') int? lunarDay,
    @JsonKey(name: 'repeatYearly') @Default(false) bool repeatYearly,
    @JsonKey(name: 'inviteCircle') @Default(false) bool inviteCircle,
    @JsonKey(name: 'childIds') @Default(<String>[]) List<String> childIds,
    @JsonKey(name: 'participants')
    @Default(<EventParticipantRecord>[])
    List<EventParticipantRecord> participants,
    @JsonKey(name: 'reminderRules')
    @Default(<EventReminderRuleRecord>[])
    List<EventReminderRuleRecord> reminderRules,
  }) = _CalendarEventRecord;

  factory CalendarEventRecord.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventRecordFromJson(json);
}
