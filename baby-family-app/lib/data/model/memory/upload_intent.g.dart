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
      variantUploads:
          (json['variantUploads'] as List<dynamic>?)
              ?.map((e) => VariantUpload.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <VariantUpload>[],
    );

Map<String, dynamic> _$UploadIntentToJson(_UploadIntent instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'status': instance.status,
      'deduplicated': instance.deduplicated,
      'upload': instance.upload?.toJson(),
      'variantUploads': instance.variantUploads.map((e) => e.toJson()).toList(),
    };

_VariantUpload _$VariantUploadFromJson(Map<String, dynamic> json) =>
    _VariantUpload(
      code: json['code'] as String?,
      upload: json['upload'] == null
          ? null
          : UploadInstruction.fromJson(json['upload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VariantUploadToJson(_VariantUpload instance) =>
    <String, dynamic>{
      'code': instance.code,
      'upload': instance.upload?.toJson(),
    };
