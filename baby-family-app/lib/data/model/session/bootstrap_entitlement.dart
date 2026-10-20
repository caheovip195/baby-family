import 'package:freezed_annotation/freezed_annotation.dart';

part 'bootstrap_entitlement.freezed.dart';
part 'bootstrap_entitlement.g.dart';

/// Quyền lợi gia đình trong bootstrap (`entitlement`).
@Freezed(when: FreezedWhenOptions.none)
abstract class BootstrapEntitlement with _$BootstrapEntitlement {
  @JsonSerializable(explicitToJson: true)
  const factory BootstrapEntitlement({
    @JsonKey(name: 'accessPhase') String? accessPhase,
    @JsonKey(name: 'trialEndsAt') DateTime? trialEndsAt,
    @JsonKey(name: 'validUntil') DateTime? validUntil,
  }) = _BootstrapEntitlement;

  factory BootstrapEntitlement.fromJson(Map<String, dynamic> json) =>
      _$BootstrapEntitlementFromJson(json);
}
