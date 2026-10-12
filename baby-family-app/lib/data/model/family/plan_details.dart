import 'package:baby_family/data/model/family/plan_info.dart';
import 'package:baby_family/data/model/family/storage_usage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_details.freezed.dart';
part 'plan_details.g.dart';

/// SUB-03 “Gói của gia đình”.
@Freezed(when: FreezedWhenOptions.none)
abstract class PlanDetails with _$PlanDetails {
  @JsonSerializable(explicitToJson: true)
  const factory PlanDetails({
    @JsonKey(name: 'plan') required PlanInfo plan,
    @JsonKey(name: 'payerUserId') String? payerUserId,
    @JsonKey(name: 'channel') @Default('') String channel,
    @JsonKey(name: 'storage') @Default([]) List<StorageUsage> storage,
    @JsonKey(name: 'aiRemaining') @Default(0) int aiRemaining,
    @JsonKey(name: 'aiTotal') @Default(0) int aiTotal,
    @JsonKey(name: 'aiRenewsAt') DateTime? aiRenewsAt,
    @JsonKey(name: 'videoMaxMinutes') @Default(0) int videoMaxMinutes,
    @JsonKey(name: 'photosPerMemory') @Default(0) int photosPerMemory,
    @JsonKey(name: 'relativeNames') @Default([]) List<String> relativeNames,
  }) = _PlanDetails;

  factory PlanDetails.fromJson(Map<String, dynamic> json) =>
      _$PlanDetailsFromJson(json);
}
