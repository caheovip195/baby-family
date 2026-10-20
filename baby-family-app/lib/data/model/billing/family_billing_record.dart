import 'package:baby_family/data/model/billing/billing_plan_record.dart';
import 'package:baby_family/data/model/billing/family_billing_usage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_billing_record.freezed.dart';
part 'family_billing_record.g.dart';

/// `GET /v1/families/{familyId}/billing` — quyền lợi + usage của gia đình;
/// `accessPhase`: INCOMPLETE | TRIAL | PAID | EXPIRED | BLOCKED.
@Freezed(when: FreezedWhenOptions.none)
abstract class FamilyBillingRecord with _$FamilyBillingRecord {
  @JsonSerializable(explicitToJson: true)
  const factory FamilyBillingRecord({
    @JsonKey(name: 'accessPhase') String? accessPhase,
    @JsonKey(name: 'licenseBlocked') @Default(false) bool licenseBlocked,
    @JsonKey(name: 'plan') BillingPlanRecord? plan,
    @JsonKey(name: 'trialEndsAt') DateTime? trialEndsAt,
    @JsonKey(name: 'validUntil') DateTime? validUntil,
    @JsonKey(name: 'inGrace') @Default(false) bool inGrace,
    @JsonKey(name: 'usage') FamilyBillingUsage? usage,
  }) = _FamilyBillingRecord;

  factory FamilyBillingRecord.fromJson(Map<String, dynamic> json) =>
      _$FamilyBillingRecordFromJson(json);
}
