// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_archive_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChildArchiveInfo _$ChildArchiveInfoFromJson(Map<String, dynamic> json) =>
    _ChildArchiveInfo(
      childId: json['childId'] as String,
      addedByUserId: json['addedByUserId'] as String?,
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
      duplicateOfChildId: json['duplicateOfChildId'] as String?,
      privateMemoryCount: (json['privateMemoryCount'] as num?)?.toInt() ?? 0,
      sharedMemoryCount: (json['sharedMemoryCount'] as num?)?.toInt() ?? 0,
      sharedWithChildIds:
          (json['sharedWithChildIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
      deletableFrom: json['deletableFrom'] == null
          ? null
          : DateTime.parse(json['deletableFrom'] as String),
    );

Map<String, dynamic> _$ChildArchiveInfoToJson(_ChildArchiveInfo instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'addedByUserId': instance.addedByUserId,
      'addedAt': instance.addedAt?.toIso8601String(),
      'duplicateOfChildId': instance.duplicateOfChildId,
      'privateMemoryCount': instance.privateMemoryCount,
      'sharedMemoryCount': instance.sharedMemoryCount,
      'sharedWithChildIds': instance.sharedWithChildIds,
      'archivedAt': instance.archivedAt?.toIso8601String(),
      'deletableFrom': instance.deletableFrom?.toIso8601String(),
    };
