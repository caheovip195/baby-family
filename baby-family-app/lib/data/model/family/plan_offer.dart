import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_offer.freezed.dart';
part 'plan_offer.g.dart';

/// Gói bán trên Store (SUB-01) — giá đã định dạng theo locale.
@Freezed(when: FreezedWhenOptions.none)
abstract class PlanOffer with _$PlanOffer {
  @JsonSerializable(explicitToJson: true)
  const factory PlanOffer({
    @JsonKey(name: 'code') required PlanState code,
    @JsonKey(name: 'storageGb') @Default(0) int storageGb,
    @JsonKey(name: 'relativeSlots') @Default(0) int relativeSlots,
    @JsonKey(name: 'priceText') @Default('') String priceText,
    @JsonKey(name: 'monthlyText') @Default('') String monthlyText,

    /// SUB-04 bảng so sánh.
    @JsonKey(name: 'photosPerMemory') int? photosPerMemory,
    @JsonKey(name: 'videoMinutes') int? videoMinutes,
    @JsonKey(name: 'voiceMinutes') int? voiceMinutes,
    @JsonKey(name: 'originalQuality') @Default(false) bool originalQuality,
    @JsonKey(name: 'aiPerMonth') int? aiPerMonth,
    @JsonKey(name: 'digestAndReview') @Default(false) bool digestAndReview,
  }) = _PlanOffer;

  factory PlanOffer.fromJson(Map<String, dynamic> json) =>
      _$PlanOfferFromJson(json);
}
