// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CirclePreferences _$CirclePreferencesFromJson(Map<String, dynamic> json) =>
    _CirclePreferences(
      instantPhotos: json['instantPhotos'] as bool? ?? false,
      dailyDigest: json['dailyDigest'] as bool? ?? true,
      digestTime: json['digestTime'] as String? ?? '19:00',
      relationNote: json['relationNote'] as String?,
      postedPhotos: (json['postedPhotos'] as num?)?.toInt() ?? 0,
      postedComments: (json['postedComments'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CirclePreferencesToJson(_CirclePreferences instance) =>
    <String, dynamic>{
      'instantPhotos': instance.instantPhotos,
      'dailyDigest': instance.dailyDigest,
      'digestTime': instance.digestTime,
      'relationNote': instance.relationNote,
      'postedPhotos': instance.postedPhotos,
      'postedComments': instance.postedComments,
    };
