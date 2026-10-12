import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mood_checkin.freezed.dart';
part 'mood_checkin.g.dart';

/// Check-in cảm xúc (US-02, mục 7.16.1).
@Freezed(when: FreezedWhenOptions.none)
abstract class MoodCheckin with _$MoodCheckin {
  @JsonSerializable(explicitToJson: true)
  const factory MoodCheckin({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'mood') required MoodCode mood,
    @JsonKey(name: 'energy') @Default(3) int energy,
    @JsonKey(name: 'needs') @Default([]) List<CoupleNeed> needs,
    @JsonKey(name: 'needMinutes') int? needMinutes,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'shared') @Default(true) bool shared,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
  }) = _MoodCheckin;

  factory MoodCheckin.fromJson(Map<String, dynamic> json) =>
      _$MoodCheckinFromJson(json);
}
