// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_intent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UploadIntent _$UploadIntentFromJson(Map<String, dynamic> json) =>
    _UploadIntent(
      assetId: json['assetId'] as String?,
      status: json['status'] as String?,
      deduplicated: json['deduplicated'] as bool? ?? false,
      upload: json['upload'] == null
          ? null
          : UploadInstruction.fromJson(json['upload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UploadIntentToJson(_UploadIntent instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'status': instance.status,
      'deduplicated': instance.deduplicated,
      'upload': instance.upload?.toJson(),
    };
