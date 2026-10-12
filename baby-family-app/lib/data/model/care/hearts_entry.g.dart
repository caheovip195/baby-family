// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hearts_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeartsEntry _$HeartsEntryFromJson(Map<String, dynamic> json) => _HeartsEntry(
  id: json['id'] as String,
  hearts: (json['hearts'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  at: DateTime.parse(json['at'] as String),
  together: json['together'] as bool? ?? false,
  missionId: json['missionId'] as String?,
  requestId: json['requestId'] as String?,
);

Map<String, dynamic> _$HeartsEntryToJson(_HeartsEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hearts': instance.hearts,
      'title': instance.title,
      'at': instance.at.toIso8601String(),
      'together': instance.together,
      'missionId': instance.missionId,
      'requestId': instance.requestId,
    };
