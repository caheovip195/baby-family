// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillingCatalog _$BillingCatalogFromJson(Map<String, dynamic> json) =>
    _BillingCatalog(
      plans:
          (json['plans'] as List<dynamic>?)
              ?.map(
                (e) => BillingPlanRecord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <BillingPlanRecord>[],
    );

Map<String, dynamic> _$BillingCatalogToJson(_BillingCatalog instance) =>
    <String, dynamic>{'plans': instance.plans.map((e) => e.toJson()).toList()};
