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
  photosPerMemory: (json['photosPerMemory'] as num?)?.toInt(),
  videoMinutes: (json['videoMinutes'] as num?)?.toInt(),
  voiceMinutes: (json['voiceMinutes'] as num?)?.toInt(),
  originalQuality: json['originalQuality'] as bool? ?? false,
  aiPerMonth: (json['aiPerMonth'] as num?)?.toInt(),
  digestAndReview: json['digestAndReview'] as bool? ?? false,
);

Map<String, dynamic> _$PlanOfferToJson(_PlanOffer instance) =>
    <String, dynamic>{
      'code': _$PlanStateEnumMap[instance.code]!,
      'storageGb': instance.storageGb,
      'relativeSlots': instance.relativeSlots,
      'priceText': instance.priceText,
      'monthlyText': instance.monthlyText,
      'photosPerMemory': instance.photosPerMemory,
      'videoMinutes': instance.videoMinutes,
      'voiceMinutes': instance.voiceMinutes,
      'originalQuality': instance.originalQuality,
      'aiPerMonth': instance.aiPerMonth,
      'digestAndReview': instance.digestAndReview,
    };

const _$PlanStateEnumMap = {
  PlanState.trial: 'trial',
  PlanState.house: 'house',
  PlanState.family: 'family',
  PlanState.expired: 'expired',
};
