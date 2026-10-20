import 'package:baby_family/data/model/billing/billing_plan_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing_catalog.freezed.dart';
part 'billing_catalog.g.dart';

/// `GET /v1/billing/plans` → `{plans: [...]}` (trial policy app đọc ở nơi khác).
@Freezed(when: FreezedWhenOptions.none)
abstract class BillingCatalog with _$BillingCatalog {
  @JsonSerializable(explicitToJson: true)
  const factory BillingCatalog({
    @JsonKey(name: 'plans')
    @Default(<BillingPlanRecord>[])
    List<BillingPlanRecord> plans,
  }) = _BillingCatalog;

  factory BillingCatalog.fromJson(Map<String, dynamic> json) =>
      _$BillingCatalogFromJson(json);
}
