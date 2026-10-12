// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) =>
    _JournalEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      showTime: json['showTime'] as bool? ?? false,
      mood:
          $enumDecodeNullable(_$JournalMoodEnumMap, json['mood']) ??
          JournalMood.calm,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      photoAsset: json['photoAsset'] as String?,
      sharedExcerpt: json['sharedExcerpt'] as bool? ?? false,
    );

Map<String, dynamic> _$JournalEntryToJson(_JournalEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'showTime': instance.showTime,
      'mood': _$JournalMoodEnumMap[instance.mood]!,
      'title': instance.title,
      'body': instance.body,
      'photoAsset': instance.photoAsset,
      'sharedExcerpt': instance.sharedExcerpt,
    };

const _$JournalMoodEnumMap = {
  JournalMood.tired: 'tired',
  JournalMood.grateful: 'grateful',
  JournalMood.worried: 'worried',
  JournalMood.calm: 'calm',
};
