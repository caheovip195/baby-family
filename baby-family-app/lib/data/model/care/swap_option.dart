import 'package:baby_family/data/model/care/mission_template.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'swap_option.freezed.dart';
part 'swap_option.g.dart';

/// Lựa chọn đổi nhiệm vụ (CARE-05): Hearts ±1, tối đa 3 lần/ngày.
@Freezed(when: FreezedWhenOptions.none)
abstract class SwapOption with _$SwapOption {
  @JsonSerializable(explicitToJson: true)
  const factory SwapOption({
    @JsonKey(name: 'missionId') required String missionId,
    @JsonKey(name: 'options') @Default([]) List<MissionTemplate> options,
    @JsonKey(name: 'swapsLeft') @Default(0) int swapsLeft,
  }) = _SwapOption;

  factory SwapOption.fromJson(Map<String, dynamic> json) =>
      _$SwapOptionFromJson(json);
}
