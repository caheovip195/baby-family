import 'package:baby_family/data/model/memory/upload_part_url.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_instruction.freezed.dart';
part 'upload_instruction.g.dart';

/// Cách tải lên object storage (`upload` của upload-intent, tài liệu kỹ thuật
/// 10.2): `single` (một PUT) hoặc `multipart` (file > 20 MiB, part
/// [partSize] byte, URL theo từng part).
@Freezed(when: FreezedWhenOptions.none)
abstract class UploadInstruction with _$UploadInstruction {
  @JsonSerializable(explicitToJson: true)
  const factory UploadInstruction({
    @JsonKey(name: 'mode') String? mode,
    @JsonKey(name: 'method') String? method,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'headers')
    @Default(<String, String>{})
    Map<String, String> headers,
    @JsonKey(name: 'partSize') int? partSize,
    @JsonKey(name: 'partCount') int? partCount,
    @JsonKey(name: 'parts')
    @Default(<UploadPartUrl>[])
    List<UploadPartUrl> parts,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
  }) = _UploadInstruction;

  factory UploadInstruction.fromJson(Map<String, dynamic> json) =>
      _$UploadInstructionFromJson(json);
}
