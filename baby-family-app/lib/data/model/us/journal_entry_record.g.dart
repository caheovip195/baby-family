// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JournalEntryRecord _$JournalEntryRecordFromJson(Map<String, dynamic> json) =>
    _JournalEntryRecord(
      id: json['id'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      mood: json['mood'] as String?,
      assetIds:
          (json['assetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$JournalEntryRecordToJson(_JournalEntryRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'mood': instance.mood,
      'assetIds': instance.assetIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
