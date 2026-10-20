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
  }) = _UploadIntent;

  factory UploadIntent.fromJson(Map<String, dynamic> json) =>
      _$UploadIntentFromJson(json);
}
