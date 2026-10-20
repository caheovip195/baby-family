// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_instruction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UploadInstruction _$UploadInstructionFromJson(Map<String, dynamic> json) =>
    _UploadInstruction(
      mode: json['mode'] as String?,
      method: json['method'] as String?,
      url: json['url'] as String?,
      headers:
          (json['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      partSize: (json['partSize'] as num?)?.toInt(),
      partCount: (json['partCount'] as num?)?.toInt(),
      parts:
          (json['parts'] as List<dynamic>?)
              ?.map((e) => UploadPartUrl.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <UploadPartUrl>[],
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$UploadInstructionToJson(_UploadInstruction instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'method': instance.method,
      'url': instance.url,
      'headers': instance.headers,
      'partSize': instance.partSize,
      'partCount': instance.partCount,
      'parts': instance.parts.map((e) => e.toJson()).toList(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
