import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_info.freezed.dart';
part 'plan_info.g.dart';

/// Gói của gia đình (mục 5, FAM-01, SUB-01/07).
@Freezed(when: FreezedWhenOptions.none)
abstract class PlanInfo with _$PlanInfo {
  @JsonSerializable(explicitToJson: true)
  const factory PlanInfo({
    @JsonKey(name: 'state') @Default(PlanState.trial) PlanState state,
    @JsonKey(name: 'startedAt') DateTime? startedAt,
    @JsonKey(name: 'endsAt') DateTime? endsAt,
    @JsonKey(name: 'storageUsedMb') @Default(0) int storageUsedMb,
    @JsonKey(name: 'storageQuotaMb') @Default(0) int storageQuotaMb,
    @JsonKey(name: 'relativeSlotsUsed') @Default(0) int relativeSlotsUsed,
    @JsonKey(name: 'relativeSlotsMax') @Default(0) int relativeSlotsMax,
  }) = _PlanInfo;

  factory PlanInfo.fromJson(Map<String, dynamic> json) =>
      _$PlanInfoFromJson(json);
}
