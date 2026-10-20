// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LetterRecord _$LetterRecordFromJson(Map<String, dynamic> json) =>
    _LetterRecord(
      id: json['id'] as String?,
      sealed: json['sealed'] as bool? ?? false,
      unlockAt: json['unlockAt'] == null
          ? null
          : DateTime.parse(json['unlockAt'] as String),
      authorUserId: json['authorUserId'] as String?,
    );

Map<String, dynamic> _$LetterRecordToJson(_LetterRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sealed': instance.sealed,
      'unlockAt': instance.unlockAt?.toIso8601String(),
      'authorUserId': instance.authorUserId,
    };
