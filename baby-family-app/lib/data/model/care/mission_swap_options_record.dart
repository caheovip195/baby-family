import 'package:baby_family/data/model/care/mission_template_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_swap_options_record.freezed.dart';
part 'mission_swap_options_record.g.dart';

/// Ba lựa chọn đổi nhiệm vụ + `optionsToken` dùng khi đổi (CARE-05).
@Freezed(when: FreezedWhenOptions.none)
abstract class MissionSwapOptionsRecord with _$MissionSwapOptionsRecord {
  @JsonSerializable(explicitToJson: true)
  const factory MissionSwapOptionsRecord({
    @JsonKey(name: 'options')
    @Default(<MissionTemplateRecord>[])
    List<MissionTemplateRecord> options,
    @JsonKey(name: 'optionsToken') String? optionsToken,
    @JsonKey(name: 'swapsLeft') @Default(0) int swapsLeft,
  }) = _MissionSwapOptionsRecord;

  factory MissionSwapOptionsRecord.fromJson(Map<String, dynamic> json) =>
      _$MissionSwapOptionsRecordFromJson(json);
}
