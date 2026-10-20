import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_status.freezed.dart';
part 'upload_status.g.dart';

/// `POST /v1/media/{id}/complete` → trạng thái asset.
@Freezed(when: FreezedWhenOptions.none)
abstract class UploadStatus with _$UploadStatus {
  @JsonSerializable(explicitToJson: true)
  const factory UploadStatus({
    @JsonKey(name: 'assetId') String? assetId,
    @JsonKey(name: 'status') String? status,
  }) = _UploadStatus;

  factory UploadStatus.fromJson(Map<String, dynamic> json) =>
      _$UploadStatusFromJson(json);
}
