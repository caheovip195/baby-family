import 'package:baby_family/data/model/care/calendar_event_record.dart';
import 'package:baby_family/data/model/care/calendar_special_day_record.dart';
import 'package:baby_family/data/model/care/mission_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_record.freezed.dart';
part 'calendar_record.g.dart';

/// `GET /families/:fid/calendar` (CARE-07). Việc của bạn đời không có Hearts.
@Freezed(when: FreezedWhenOptions.none)
abstract class CalendarRecord with _$CalendarRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CalendarRecord({
    @JsonKey(name: 'events')
    @Default(<CalendarEventRecord>[])
    List<CalendarEventRecord> events,
    @JsonKey(name: 'missions')
    @Default(<MissionRecord>[])
    List<MissionRecord> missions,
    @JsonKey(name: 'specialDays')
    @Default(<CalendarSpecialDayRecord>[])
    List<CalendarSpecialDayRecord> specialDays,
  }) = _CalendarRecord;

  factory CalendarRecord.fromJson(Map<String, dynamic> json) =>
      _$CalendarRecordFromJson(json);
}
