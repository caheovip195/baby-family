// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanDetails _$PlanDetailsFromJson(Map<String, dynamic> json) => _PlanDetails(
  plan: PlanInfo.fromJson(json['plan'] as Map<String, dynamic>),
  payerUserId: json['payerUserId'] as String?,
  channel: json['channel'] as String? ?? '',
  storage:
      (json['storage'] as List<dynamic>?)
          ?.map((e) => StorageUsage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  aiRemaining: (json['aiRemaining'] as num?)?.toInt() ?? 0,
  aiTotal: (json['aiTotal'] as num?)?.toInt() ?? 0,
  aiRenewsAt: json['aiRenewsAt'] == null
      ? null
      : DateTime.parse(json['aiRenewsAt'] as String),
  videoMaxMinutes: (json['videoMaxMinutes'] as num?)?.toInt() ?? 0,
  photosPerMemory: (json['photosPerMemory'] as num?)?.toInt() ?? 0,
  relativeNames:
      (json['relativeNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$PlanDetailsToJson(_PlanDetails instance) =>
    <String, dynamic>{
      'plan': instance.plan.toJson(),
      'payerUserId': instance.payerUserId,
      'channel': instance.channel,
      'storage': instance.storage.map((e) => e.toJson()).toList(),
      'aiRemaining': instance.aiRemaining,
      'aiTotal': instance.aiTotal,
      'aiRenewsAt': instance.aiRenewsAt?.toIso8601String(),
      'videoMaxMinutes': instance.videoMaxMinutes,
      'photosPerMemory': instance.photosPerMemory,
      'relativeNames': instance.relativeNames,
    };
