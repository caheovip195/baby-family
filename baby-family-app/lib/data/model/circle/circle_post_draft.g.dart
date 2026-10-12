// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_post_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CirclePostDraft _$CirclePostDraftFromJson(Map<String, dynamic> json) =>
    _CirclePostDraft(
      mediaAssets:
          (json['mediaAssets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      childIds:
          (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      takenAt: json['takenAt'] == null
          ? null
          : DateTime.parse(json['takenAt'] as String),
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$CirclePostDraftToJson(_CirclePostDraft instance) =>
    <String, dynamic>{
      'mediaAssets': instance.mediaAssets,
      'childIds': instance.childIds,
      'takenAt': instance.takenAt?.toIso8601String(),
      'message': instance.message,
    };
