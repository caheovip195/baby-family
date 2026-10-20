import 'package:baby_family/data/model/pregnancy/journey_week_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey_record.freezed.dart';
part 'journey_record.g.dart';

/// `GET /pregnancies/:id/journey` (PREG-01).
@Freezed(when: FreezedWhenOptions.none)
abstract class JourneyRecord with _$JourneyRecord {
  @JsonSerializable(explicitToJson: true)
  const factory JourneyRecord({
    @JsonKey(name: 'pregnancyId') String? pregnancyId,
    @JsonKey(name: 'currentWeek') int? currentWeek,
    @JsonKey(name: 'currentDay') int? currentDay,
    @JsonKey(name: 'daysLeft') int? daysLeft,
    @JsonKey(name: 'week') JourneyWeekRecord? week,
  }) = _JourneyRecord;

  factory JourneyRecord.fromJson(Map<String, dynamic> json) =>
      _$JourneyRecordFromJson(json);
}
