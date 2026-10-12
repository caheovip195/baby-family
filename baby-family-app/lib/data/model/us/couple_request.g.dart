// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoupleRequest _$CoupleRequestFromJson(
  Map<String, dynamic> json,
) => _CoupleRequest(
  id: json['id'] as String,
  kind:
      $enumDecodeNullable(_$RequestKindEnumMap, json['kind']) ??
      RequestKind.task,
  templateCode: json['templateCode'] as String?,
  needCode: $enumDecodeNullable(_$CoupleNeedEnumMap, json['needCode']),
  title: json['title'] as String? ?? '',
  message: json['message'] as String?,
  childIds:
      (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  dueLabel: json['dueLabel'] as String?,
  dueAt: json['dueAt'] == null ? null : DateTime.parse(json['dueAt'] as String),
  durationMin: (json['durationMin'] as num?)?.toInt(),
  urgency:
      $enumDecodeNullable(_$RequestUrgencyEnumMap, json['urgency']) ??
      RequestUrgency.normal,
  status:
      $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
      RequestStatus.sent,
  senderId: json['senderId'] as String,
  receiverId: json['receiverId'] as String,
  volunteered: json['volunteered'] as bool? ?? false,
  declineReason: json['declineReason'] as String?,
  sentAt: DateTime.parse(json['sentAt'] as String),
  seenAt: json['seenAt'] == null
      ? null
      : DateTime.parse(json['seenAt'] as String),
  acceptedAt: json['acceptedAt'] == null
      ? null
      : DateTime.parse(json['acceptedAt'] as String),
  doneAt: json['doneAt'] == null
      ? null
      : DateTime.parse(json['doneAt'] as String),
  declinedAt: json['declinedAt'] == null
      ? null
      : DateTime.parse(json['declinedAt'] as String),
  remindAt: json['remindAt'] == null
      ? null
      : DateTime.parse(json['remindAt'] as String),
);

Map<String, dynamic> _$CoupleRequestToJson(_CoupleRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': _$RequestKindEnumMap[instance.kind]!,
      'templateCode': instance.templateCode,
      'needCode': _$CoupleNeedEnumMap[instance.needCode],
      'title': instance.title,
      'message': instance.message,
      'childIds': instance.childIds,
      'dueLabel': instance.dueLabel,
      'dueAt': instance.dueAt?.toIso8601String(),
      'durationMin': instance.durationMin,
      'urgency': _$RequestUrgencyEnumMap[instance.urgency]!,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'volunteered': instance.volunteered,
      'declineReason': instance.declineReason,
      'sentAt': instance.sentAt.toIso8601String(),
      'seenAt': instance.seenAt?.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'doneAt': instance.doneAt?.toIso8601String(),
      'declinedAt': instance.declinedAt?.toIso8601String(),
      'remindAt': instance.remindAt?.toIso8601String(),
    };

const _$RequestKindEnumMap = {
  RequestKind.task: 'task',
  RequestKind.need: 'need',
};

const _$CoupleNeedEnumMap = {
  CoupleNeed.rest: 'rest',
  CoupleNeed.childcare: 'childcare',
  CoupleNeed.quiet: 'quiet',
  CoupleNeed.hug: 'hug',
  CoupleNeed.talk: 'talk',
  CoupleNeed.encouragement: 'encouragement',
};

const _$RequestUrgencyEnumMap = {
  RequestUrgency.normal: 'normal',
  RequestUrgency.soon: 'soon',
};

const _$RequestStatusEnumMap = {
  RequestStatus.sent: 'sent',
  RequestStatus.seen: 'seen',
  RequestStatus.accepted: 'accepted',
  RequestStatus.done: 'done',
  RequestStatus.declined: 'declined',
  RequestStatus.acknowledged: 'acknowledged',
  RequestStatus.expired: 'expired',
  RequestStatus.cancelled: 'cancelled',
};
