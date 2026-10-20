import 'package:baby_family/data/model/pregnancy/journey_size_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey_week_record.freezed.dart';
part 'journey_week_record.g.dart';

@Freezed(when: FreezedWhenOptions.none)
abstract class JourneyWeekRecord with _$JourneyWeekRecord {
  @JsonSerializable(explicitToJson: true)
  const factory JourneyWeekRecord({
    @JsonKey(name: 'number') int? number,
    @JsonKey(name: 'size') JourneySizeRecord? size,
    @JsonKey(name: 'tip') String? tip,
  }) = _JourneyWeekRecord;

  factory JourneyWeekRecord.fromJson(Map<String, dynamic> json) =>
      _$JourneyWeekRecordFromJson(json);
}
