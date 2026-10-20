import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_part_url.freezed.dart';
part 'upload_part_url.g.dart';

/// URL ký cho một part của upload multipart (`n` bắt đầu từ 1).
@Freezed(when: FreezedWhenOptions.none)
abstract class UploadPartUrl with _$UploadPartUrl {
  @JsonSerializable(explicitToJson: true)
  const factory UploadPartUrl({
    @JsonKey(name: 'n') required int n,
    @JsonKey(name: 'url') required String url,
  }) = _UploadPartUrl;

  factory UploadPartUrl.fromJson(Map<String, dynamic> json) =>
      _$UploadPartUrlFromJson(json);
}
