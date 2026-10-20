import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_settings_record.freezed.dart';
part 'family_settings_record.g.dart';

/// `GET/PATCH /families/:fid/settings` (ONB-08, FAM-07). Circle chỉ nhận
/// `showLunar`.
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilySettingsRecord with _$FamilySettingsRecord {
  @JsonSerializable(explicitToJson: true)
  const factory FamilySettingsRecord({
    @JsonKey(name: 'showLunar') bool? showLunar,
    @JsonKey(name: 'circleCanSeeTree') bool? circleCanSeeTree,
    @JsonKey(name: 'defaultVisibility') String? defaultVisibility,
    @JsonKey(name: 'requireCircleReview') bool? requireCircleReview,
    @JsonKey(name: 'traditionalUseLunar') bool? traditionalUseLunar,
    @JsonKey(name: 'milestoneSuggestions') bool? milestoneSuggestions,
  }) = _FamilySettingsRecord;

  factory FamilySettingsRecord.fromJson(Map<String, dynamic> json) =>
      _$FamilySettingsRecordFromJson(json);
}
