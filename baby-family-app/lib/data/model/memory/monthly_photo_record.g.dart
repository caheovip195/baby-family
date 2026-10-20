// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_photo_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyPhotoRecord _$MonthlyPhotoRecordFromJson(Map<String, dynamic> json) =>
    _MonthlyPhotoRecord(
      monthIndex: (json['monthIndex'] as num?)?.toInt(),
      memoryId: json['memoryId'] as String?,
      url: json['url'] as String?,
      occurredAt: json['occurredAt'] == null
          ? null
          : DateTime.parse(json['occurredAt'] as String),
    );

Map<String, dynamic> _$MonthlyPhotoRecordToJson(_MonthlyPhotoRecord instance) =>
    <String, dynamic>{
      'monthIndex': instance.monthIndex,
      'memoryId': instance.memoryId,
      'url': instance.url,
      'occurredAt': instance.occurredAt?.toIso8601String(),
    };
