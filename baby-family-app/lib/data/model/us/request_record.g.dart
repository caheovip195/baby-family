// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestRecord _$RequestRecordFromJson(
  Map<String, dynamic> json,
) => _RequestRecord(
  id: json['id'] as String?,
  senderUserId: json['senderUserId'] as String?,
  receiverUserId: json['receiverUserId'] as String?,
  kind: json['kind'] as String?,
  needCode: json['needCode'] as String?,
  title: json['title'] as String?,
  durationMin: (json['durationMin'] as num?)?.toInt(),
  childIds:
      (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  message: json['message'] as String?,
  dueKind: json['dueKind'] as String?,
  dueAt: json['dueAt'] == null ? null : DateTime.parse(json['dueAt'] as String),
  urgency: json['urgency'] as String?,
  status: json['status'] as String?,
  volunteered: json['volunteered'] as bool? ?? false,
  declineReason: json['declineReason'] as String?,
  reminderAt: json['reminderAt'] == null
      ? null
      : DateTime.parse(json['reminderAt'] as String),
  seenAt: json['seenAt'] == null
      ? null
      : DateTime.parse(json['seenAt'] as String),
  respondedAt: json['respondedAt'] == null
      ? null
      : DateTime.parse(json['respondedAt'] as String),
  doneAt: json['doneAt'] == null
      ? null
      : DateTime.parse(json['doneAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RequestRecordToJson(_RequestRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderUserId': instance.senderUserId,
      'receiverUserId': instance.receiverUserId,
      'kind': instance.kind,
      'needCode': instance.needCode,
      'title': instance.title,
      'durationMin': instance.durationMin,
      'childIds': instance.childIds,
      'message': instance.message,
      'dueKind': instance.dueKind,
      'dueAt': instance.dueAt?.toIso8601String(),
      'urgency': instance.urgency,
      'status': instance.status,
      'volunteered': instance.volunteered,
      'declineReason': instance.declineReason,
      'reminderAt': instance.reminderAt?.toIso8601String(),
      'seenAt': instance.seenAt?.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'doneAt': instance.doneAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
