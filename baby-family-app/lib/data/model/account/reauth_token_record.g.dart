// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reauth_token_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReauthTokenRecord _$ReauthTokenRecordFromJson(Map<String, dynamic> json) =>
    _ReauthTokenRecord(
      reauthToken: json['reauthToken'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$ReauthTokenRecordToJson(_ReauthTokenRecord instance) =>
    <String, dynamic>{
      'reauthToken': instance.reauthToken,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
