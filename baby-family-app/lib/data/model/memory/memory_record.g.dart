// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoryRecord _$MemoryRecordFromJson(Map<String, dynamic> json) =>
    _MemoryRecord(
      id: json['id'] as String?,
      familyId: json['familyId'] as String?,
      kind: json['kind'] as String?,
      status: json['status'] as String?,
      version: (json['version'] as num?)?.toInt(),
      authorUserId: json['authorUserId'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      occurredAt: json['occurredAt'] == null
          ? null
          : DateTime.parse(json['occurredAt'] as String),
      visibility: json['visibility'] as String?,
      familyMoment: json['familyMoment'] as bool? ?? false,
      childIds:
          (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      pregnancyId: json['pregnancyId'] as String?,
      pregnancyWeek: (json['pregnancyWeek'] as num?)?.toInt(),
      feeling: json['feeling'] as String?,
      quoteContext: json['quoteContext'] as String?,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      commentsEnabled: json['commentsEnabled'] as bool? ?? true,
      reactions:
          (json['reactions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
      myReaction: json['myReaction'] as String?,
      perspectiveCount: (json['perspectiveCount'] as num?)?.toInt() ?? 0,
      coverAssetId: json['coverAssetId'] as String?,
      assets:
          (json['assets'] as List<dynamic>?)
              ?.map((e) => MediaAssetRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaAssetRecord>[],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      trashedAt: json['trashedAt'] == null
          ? null
          : DateTime.parse(json['trashedAt'] as String),
      trashedBy: json['trashedBy'] as String?,
      purgeAfter: json['purgeAfter'] == null
          ? null
          : DateTime.parse(json['purgeAfter'] as String),
    );

Map<String, dynamic> _$MemoryRecordToJson(_MemoryRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'kind': instance.kind,
      'status': instance.status,
      'version': instance.version,
      'authorUserId': instance.authorUserId,
      'title': instance.title,
      'body': instance.body,
      'occurredAt': instance.occurredAt?.toIso8601String(),
      'visibility': instance.visibility,
      'familyMoment': instance.familyMoment,
      'childIds': instance.childIds,
      'pregnancyId': instance.pregnancyId,
      'pregnancyWeek': instance.pregnancyWeek,
      'feeling': instance.feeling,
      'quoteContext': instance.quoteContext,
      'commentCount': instance.commentCount,
      'commentsEnabled': instance.commentsEnabled,
      'reactions': instance.reactions,
      'myReaction': instance.myReaction,
      'perspectiveCount': instance.perspectiveCount,
      'coverAssetId': instance.coverAssetId,
      'assets': instance.assets.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'trashedAt': instance.trashedAt?.toIso8601String(),
      'trashedBy': instance.trashedBy,
      'purgeAfter': instance.purgeAfter?.toIso8601String(),
    };
