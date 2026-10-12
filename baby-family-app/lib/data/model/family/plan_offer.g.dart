// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanOffer _$PlanOfferFromJson(Map<String, dynamic> json) => _PlanOffer(
  code: $enumDecode(_$PlanStateEnumMap, json['code']),
  storageGb: (json['storageGb'] as num?)?.toInt() ?? 0,
  relativeSlots: (json['relativeSlots'] as num?)?.toInt() ?? 0,
  priceText: json['priceText'] as String? ?? '',
  monthlyText: json['monthlyText'] as String? ?? '',
);

Map<String, dynamic> _$PlanOfferToJson(_PlanOffer instance) =>
    <String, dynamic>{
      'code': _$PlanStateEnumMap[instance.code]!,
      'storageGb': instance.storageGb,
      'relativeSlots': instance.relativeSlots,
      'priceText': instance.priceText,
      'monthlyText': instance.monthlyText,
    };

const _$PlanStateEnumMap = {
  PlanState.trial: 'trial',
  PlanState.house: 'house',
  PlanState.family: 'family',
  PlanState.expired: 'expired',
};
