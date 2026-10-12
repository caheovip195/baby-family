// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyPhoto _$MonthlyPhotoFromJson(Map<String, dynamic> json) =>
    _MonthlyPhoto(
      id: json['id'] as String,
      childId: json['childId'] as String,
      monthIndex: (json['monthIndex'] as num).toInt(),
      memoryId: json['memoryId'] as String?,
      asset: json['asset'] as String?,
      takenAt: json['takenAt'] == null
          ? null
          : DateTime.parse(json['takenAt'] as String),
    );

Map<String, dynamic> _$MonthlyPhotoToJson(_MonthlyPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'monthIndex': instance.monthIndex,
      'memoryId': instance.memoryId,
      'asset': instance.asset,
      'takenAt': instance.takenAt?.toIso8601String(),
    };
