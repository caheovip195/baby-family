// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_draft_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoryDraftItem _$MemoryDraftItemFromJson(Map<String, dynamic> json) =>
    _MemoryDraftItem(
      id: json['id'] as String,
      kind:
          $enumDecodeNullable(_$MemoryKindEnumMap, json['kind']) ??
          MemoryKind.photo,
      title: json['title'] as String? ?? '',
      childIds:
          (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      location:
          $enumDecodeNullable(_$DraftLocationEnumMap, json['location']) ??
          DraftLocation.device,
      deviceName: json['deviceName'] as String?,
      mediaAssets:
          (json['mediaAssets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      extraCount: (json['extraCount'] as num?)?.toInt() ?? 0,
      voiceDurationSec: (json['voiceDurationSec'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MemoryDraftItemToJson(_MemoryDraftItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': _$MemoryKindEnumMap[instance.kind]!,
      'title': instance.title,
      'childIds': instance.childIds,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'location': _$DraftLocationEnumMap[instance.location]!,
      'deviceName': instance.deviceName,
      'mediaAssets': instance.mediaAssets,
      'extraCount': instance.extraCount,
      'voiceDurationSec': instance.voiceDurationSec,
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

const _$DraftLocationEnumMap = {
  DraftLocation.device: 'device',
  DraftLocation.cloud: 'cloud',
};
