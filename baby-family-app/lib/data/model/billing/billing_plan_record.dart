import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing_plan_record.freezed.dart';
part 'billing_plan_record.g.dart';

/// Gói trong catalog server (`GET /v1/billing/plans`): quota/feature theo
/// version — app không suy quyền từ tên gói.
@Freezed(when: FreezedWhenOptions.none)
abstract class BillingPlanRecord with _$BillingPlanRecord {
  @JsonSerializable(explicitToJson: true)
  const factory BillingPlanRecord({
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'displayName')
    @Default(<String, String>{})
    Map<String, String> displayName,
    @JsonKey(name: 'displayOrder') @Default(0) int displayOrder,
    @JsonKey(name: 'version') int? version,
    @JsonKey(name: 'quotas') @Default(<String, num>{}) Map<String, num> quotas,
    @JsonKey(name: 'features')
    @Default(<String, bool>{})
    Map<String, bool> features,
  }) = _BillingPlanRecord;

  factory BillingPlanRecord.fromJson(Map<String, dynamic> json) =>
      _$BillingPlanRecordFromJson(json);
}
