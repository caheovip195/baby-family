import 'package:baby_family/data/model/memory/memory.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_recap.freezed.dart';
part 'weekly_recap.g.dart';

/// REC-02 “Tuần của nhà mình”.
@Freezed(when: FreezedWhenOptions.none)
abstract class WeeklyRecap with _$WeeklyRecap {
  @JsonSerializable(explicitToJson: true)
  const factory WeeklyRecap({
    /// Id recap của server (null = bản mock).
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'start') required DateTime start,
    @JsonKey(name: 'end') required DateTime end,
    @JsonKey(name: 'headline') @Default('') String headline,
    @JsonKey(name: 'moments') @Default(0) int moments,
    @JsonKey(name: 'firsts') @Default(0) int firsts,
    @JsonKey(name: 'quotes') @Default(0) int quotes,
    @JsonKey(name: 'heroAssets') @Default([]) List<String> heroAssets,
    @JsonKey(name: 'highlights') @Default([]) List<Memory> highlights,
    @JsonKey(name: 'togetherTitle') String? togetherTitle,
    @JsonKey(name: 'togetherBody') String? togetherBody,
    @JsonKey(name: 'pageCount') @Default(1) int pageCount,

    /// REC-02 (BF-20261030-004): gói cho chia sẻ với người thân / đang chia
    /// sẻ / ký ức đã lưu vào timeline.
    @JsonKey(name: 'canShare') @Default(false) bool canShare,
    @JsonKey(name: 'shared') @Default(false) bool shared,
    @JsonKey(name: 'memoryId') String? memoryId,
  }) = _WeeklyRecap;

  factory WeeklyRecap.fromJson(Map<String, dynamic> json) =>
      _$WeeklyRecapFromJson(json);
}
