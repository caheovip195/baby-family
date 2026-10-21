import 'package:baby_family/data/model/memory/upload_instruction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_intent.freezed.dart';
part 'upload_intent.g.dart';

/// `POST /v1/media/upload-intents`: asset + chỉ dẫn tải lên; `deduplicated`
/// = nội dung đã có trên server, không cần tải.
@Freezed(when: FreezedWhenOptions.none)
abstract class UploadIntent with _$UploadIntent {
  @JsonSerializable(explicitToJson: true)
  const factory UploadIntent({
    @JsonKey(name: 'assetId') String? assetId,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'deduplicated') @Default(false) bool deduplicated,
    @JsonKey(name: 'upload') UploadInstruction? upload,

    /// Phiên upload nhiều biến thể (BF-20261021-008): PUT riêng từng biến thể
    /// client đã tạo.
    @JsonKey(name: 'variantUploads')
    @Default(<VariantUpload>[])
    List<VariantUpload> variantUploads,
  }) = _UploadIntent;

  factory UploadIntent.fromJson(Map<String, dynamic> json) =>
      _$UploadIntentFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class VariantUpload with _$VariantUpload {
  @JsonSerializable(explicitToJson: true)
  const factory VariantUpload({
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'upload') UploadInstruction? upload,
  }) = _VariantUpload;

  factory VariantUpload.fromJson(Map<String, dynamic> json) =>
      _$VariantUploadFromJson(json);
}
