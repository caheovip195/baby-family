// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_method_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignInMethodRecord _$SignInMethodRecordFromJson(Map<String, dynamic> json) =>
    _SignInMethodRecord(
      provider: json['provider'] as String?,
      linkedAt: json['linkedAt'] == null
          ? null
          : DateTime.parse(json['linkedAt'] as String),
      maskedHint: json['maskedHint'] as String?,
    );

Map<String, dynamic> _$SignInMethodRecordToJson(_SignInMethodRecord instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'linkedAt': instance.linkedAt?.toIso8601String(),
      'maskedHint': instance.maskedHint,
    };
