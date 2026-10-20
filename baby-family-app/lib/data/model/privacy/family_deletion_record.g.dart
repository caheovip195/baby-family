// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_deletion_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyDeletionRecord _$FamilyDeletionRecordFromJson(
  Map<String, dynamic> json,
) => _FamilyDeletionRecord(
  id: json['id'] as String?,
  status: json['status'] as String?,
  requestedBy: json['requestedBy'] as String?,
  scheduledFor: json['scheduledFor'] == null
      ? null
      : DateTime.parse(json['scheduledFor'] as String),
  graceDays: (json['graceDays'] as num?)?.toInt(),
);

Map<String, dynamic> _$FamilyDeletionRecordToJson(
  _FamilyDeletionRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'requestedBy': instance.requestedBy,
  'scheduledFor': instance.scheduledFor?.toIso8601String(),
  'graceDays': instance.graceDays,
};
