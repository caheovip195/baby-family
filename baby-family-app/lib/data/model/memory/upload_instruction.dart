import 'package:baby_family/data/model/memory/upload_part_url.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_instruction.freezed.dart';
part 'upload_instruction.g.dart';

/// Cách tải lên object storage (`upload` của upload-intent, tài liệu kỹ thuật
/// 10.2): `single` hoặc `multipart` (file > 20 MiB, part [partSize] byte,
/// URL theo từng part). `single` có [method] `POST` (form có [fields] là
/// policy đã ký: key, Content-Type, đúng dung lượng, SHA-256) hoặc `PUT`
/// (gửi kèm [headers] đã ký).
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
    @JsonKey(name: 'fields')
    @Default(<String, String>{})
    Map<String, String> fields,
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
