// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bump_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BumpPhoto _$BumpPhotoFromJson(Map<String, dynamic> json) => _BumpPhoto(
  id: json['id'] as String,
  pregnancyId: json['pregnancyId'] as String,
  week: (json['week'] as num).toInt(),
  asset: json['asset'] as String?,
  memoryId: json['memoryId'] as String?,
  takenAt: json['takenAt'] == null
      ? null
      : DateTime.parse(json['takenAt'] as String),
);

Map<String, dynamic> _$BumpPhotoToJson(_BumpPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pregnancyId': instance.pregnancyId,
      'week': instance.week,
      'asset': instance.asset,
      'memoryId': instance.memoryId,
      'takenAt': instance.takenAt?.toIso8601String(),
    };
