// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Memory _$MemoryFromJson(Map<String, dynamic> json) => _Memory(
  id: json['id'] as String,
  familyId: json['familyId'] as String,
  kind: $enumDecode(_$MemoryKindEnumMap, json['kind']),
  title: json['title'] as String?,
  body: json['body'] as String?,
  quoteContext: json['quoteContext'] as String?,
  childIds:
      (json['childIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  authorId: json['authorId'] as String,
  occurredAt: DateTime.parse(json['occurredAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  mediaAssets:
      (json['mediaAssets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  visibility:
      $enumDecodeNullable(_$MemoryVisibilityEnumMap, json['visibility']) ??
      MemoryVisibility.family,
  feeling: json['feeling'] as String?,
  people:
      (json['people'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  locationLabel: json['locationLabel'] as String?,
  milestoneCode: json['milestoneCode'] as String?,
  milestoneTitle: json['milestoneTitle'] as String?,
  monthIndex: (json['monthIndex'] as num?)?.toInt(),
  pregnancyWeek: (json['pregnancyWeek'] as num?)?.toInt(),
  pregnancyDay: (json['pregnancyDay'] as num?)?.toInt(),
  voiceDurationSec: (json['voiceDurationSec'] as num?)?.toInt(),
  voiceUrl: json['voiceUrl'] as String?,
  sealedUntil: json['sealedUntil'] == null
      ? null
      : DateTime.parse(json['sealedUntil'] as String),
  missionId: json['missionId'] as String?,
  reactions:
      (json['reactions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  myReaction: json['myReaction'] as String?,
  reactorNames:
      (json['reactorNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
  commentsEnabled: json['commentsEnabled'] as bool? ?? true,
  perspectiveCount: (json['perspectiveCount'] as num?)?.toInt() ?? 0,
  perspectiveAuthorId: json['perspectiveAuthorId'] as String?,
  perspectivePreview: json['perspectivePreview'] as String?,
  isFavorite: json['isFavorite'] as bool? ?? false,
  pinned: json['pinned'] as bool? ?? false,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  deletedByUserId: json['deletedByUserId'] as String?,
  rejectReason: json['rejectReason'] as String?,
  mediaVideos:
      (json['mediaVideos'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList() ??
      const [],
  uploadDone: (json['uploadDone'] as num?)?.toInt(),
  uploadTotal: (json['uploadTotal'] as num?)?.toInt(),
  uploadFailed: json['uploadFailed'] as bool? ?? false,
);

Map<String, dynamic> _$MemoryToJson(_Memory instance) => <String, dynamic>{
  'id': instance.id,
  'familyId': instance.familyId,
  'kind': _$MemoryKindEnumMap[instance.kind]!,
  'title': instance.title,
  'body': instance.body,
  'quoteContext': instance.quoteContext,
  'childIds': instance.childIds,
  'authorId': instance.authorId,
  'occurredAt': instance.occurredAt.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'mediaAssets': instance.mediaAssets,
  'visibility': _$MemoryVisibilityEnumMap[instance.visibility]!,
  'feeling': instance.feeling,
  'people': instance.people,
  'locationLabel': instance.locationLabel,
  'milestoneCode': instance.milestoneCode,
  'milestoneTitle': instance.milestoneTitle,
  'monthIndex': instance.monthIndex,
  'pregnancyWeek': instance.pregnancyWeek,
  'pregnancyDay': instance.pregnancyDay,
  'voiceDurationSec': instance.voiceDurationSec,
  'voiceUrl': instance.voiceUrl,
  'sealedUntil': instance.sealedUntil?.toIso8601String(),
  'missionId': instance.missionId,
  'reactions': instance.reactions,
  'myReaction': instance.myReaction,
  'reactorNames': instance.reactorNames,
  'commentCount': instance.commentCount,
  'commentsEnabled': instance.commentsEnabled,
  'perspectiveCount': instance.perspectiveCount,
  'perspectiveAuthorId': instance.perspectiveAuthorId,
  'perspectivePreview': instance.perspectivePreview,
  'isFavorite': instance.isFavorite,
  'pinned': instance.pinned,
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'deletedByUserId': instance.deletedByUserId,
  'rejectReason': instance.rejectReason,
  'mediaVideos': instance.mediaVideos,
  'uploadDone': instance.uploadDone,
  'uploadTotal': instance.uploadTotal,
  'uploadFailed': instance.uploadFailed,
};

const _$MemoryKindEnumMap = {
  MemoryKind.photo: 'photo',
  MemoryKind.diary: 'diary',
  MemoryKind.voice: 'voice',
  MemoryKind.quote: 'quote',
  MemoryKind.monthlyPhoto: 'monthlyPhoto',
  MemoryKind.keepsake: 'keepsake',
  MemoryKind.letter: 'letter',
  MemoryKind.ultrasound: 'ultrasound',
  MemoryKind.bump: 'bump',
  MemoryKind.milestone: 'milestone',
  MemoryKind.fromMission: 'fromMission',
};

const _$MemoryVisibilityEnumMap = {
  MemoryVisibility.family: 'family',
  MemoryVisibility.parents: 'parents',
  MemoryVisibility.onlyMe: 'onlyMe',
};
