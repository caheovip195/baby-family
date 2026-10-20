// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JournalList _$JournalListFromJson(Map<String, dynamic> json) => _JournalList(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => JournalEntryRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <JournalEntryRecord>[],
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$JournalListToJson(_JournalList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
