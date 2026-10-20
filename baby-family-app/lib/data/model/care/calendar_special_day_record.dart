import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_special_day_record.freezed.dart';
part 'calendar_special_day_record.g.dart';

/// Ngày đặc biệt server tự tính: sinh nhật, tròn tháng của bé.
@Freezed(when: FreezedWhenOptions.none)
abstract class CalendarSpecialDayRecord with _$CalendarSpecialDayRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CalendarSpecialDayRecord({
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'childName') String? childName,
    @JsonKey(name: 'ageYears') int? ageYears,
    @JsonKey(name: 'ageMonths') int? ageMonths,
  }) = _CalendarSpecialDayRecord;

  factory CalendarSpecialDayRecord.fromJson(Map<String, dynamic> json) =>
      _$CalendarSpecialDayRecordFromJson(json);
}
