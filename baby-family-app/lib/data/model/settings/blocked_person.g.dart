// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockedPerson _$BlockedPersonFromJson(Map<String, dynamic> json) =>
    _BlockedPerson(
      id: json['id'] as String,
      name: json['name'] as String,
      context: json['context'] as String?,
      blockedAt: json['blockedAt'] == null
          ? null
          : DateTime.parse(json['blockedAt'] as String),
    );

Map<String, dynamic> _$BlockedPersonToJson(_BlockedPerson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'context': instance.context,
      'blockedAt': instance.blockedAt?.toIso8601String(),
    };
