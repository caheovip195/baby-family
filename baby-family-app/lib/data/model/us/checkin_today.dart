import 'package:baby_family/data/model/us/checkin_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkin_today.freezed.dart';
part 'checkin_today.g.dart';

/// Check-in còn hiệu lực của tôi và của bạn đời (`GET …/us/checkins/today`).
@Freezed(when: FreezedWhenOptions.none)
abstract class CheckinToday with _$CheckinToday {
  @JsonSerializable(explicitToJson: true)
  const factory CheckinToday({
    @JsonKey(name: 'mine') CheckinRecord? mine,
    @JsonKey(name: 'partner') CheckinRecord? partner,
  }) = _CheckinToday;

  factory CheckinToday.fromJson(Map<String, dynamic> json) =>
      _$CheckinTodayFromJson(json);
}
