import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_billing_usage.freezed.dart';
part 'family_billing_usage.g.dart';

/// Usage của gia đình; số byte server gửi dạng chuỗi số nguyên.
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilyBillingUsage with _$FamilyBillingUsage {
  @JsonSerializable(explicitToJson: true)
  const factory FamilyBillingUsage({
    @JsonKey(name: 'storageBytes') String? storageBytes,
    @JsonKey(name: 'memoryCount') @Default(0) int memoryCount,
  }) = _FamilyBillingUsage;

  factory FamilyBillingUsage.fromJson(Map<String, dynamic> json) =>
      _$FamilyBillingUsageFromJson(json);
}
