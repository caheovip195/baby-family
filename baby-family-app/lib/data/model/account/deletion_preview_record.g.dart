// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deletion_preview_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeletionPreviewRecord _$DeletionPreviewRecordFromJson(
  Map<String, dynamic> json,
) => _DeletionPreviewRecord(
  graceDays: (json['graceDays'] as num?)?.toInt(),
  familyId: json['familyId'] as String?,
  familyChoices:
      (json['familyChoices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  familyAfterDeletion: json['familyAfterDeletion'] as String?,
  isPayer: json['isPayer'] as bool? ?? false,
);

Map<String, dynamic> _$DeletionPreviewRecordToJson(
  _DeletionPreviewRecord instance,
) => <String, dynamic>{
  'graceDays': instance.graceDays,
  'familyId': instance.familyId,
  'familyChoices': instance.familyChoices,
  'familyAfterDeletion': instance.familyAfterDeletion,
  'isPayer': instance.isPayer,
};
