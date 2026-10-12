import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';
part 'calendar_event.g.dart';

/// Mục lịch / sự kiện (CARE-07, CAL-02). Nhiệm vụ trên lịch có `kind = mission`.
@Freezed(when: FreezedWhenOptions.none)
abstract class CalendarEvent with _$CalendarEvent {
  @JsonSerializable(explicitToJson: true)
  const factory CalendarEvent({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'kind')
    @Default(CalendarEventKind.family)
    CalendarEventKind kind,
    @JsonKey(name: 'date') required DateTime date,
    @JsonKey(name: 'time') String? time,
    @JsonKey(name: 'allDay') @Default(false) bool allDay,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'childIds') @Default([]) List<String> childIds,
    @JsonKey(name: 'participantUserIds')
    @Default([])
    List<String> participantUserIds,
    @JsonKey(name: 'lunar') @Default(false) bool lunar,
    @JsonKey(name: 'lunarDay') int? lunarDay,
    @JsonKey(name: 'lunarMonth') int? lunarMonth,
    @JsonKey(name: 'repeatYearly') @Default(false) bool repeatYearly,
    @JsonKey(name: 'inviteFamily') @Default(false) bool inviteFamily,
    @JsonKey(name: 'reminders') @Default([]) List<String> reminders,
    @JsonKey(name: 'ownerKind') MissionOwnerKind? ownerKind,
    @JsonKey(name: 'missionId') String? missionId,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
}
