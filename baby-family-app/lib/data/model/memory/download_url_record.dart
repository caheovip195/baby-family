import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_url_record.freezed.dart';
part 'download_url_record.g.dart';

/// Link tải bản gốc, hết hạn sau ~10 phút.
@Freezed(when: FreezedWhenOptions.none)
abstract class DownloadUrlRecord with _$DownloadUrlRecord {
  @JsonSerializable(explicitToJson: true)
  const factory DownloadUrlRecord({
    @JsonKey(name: 'assetId') String? assetId,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'fileName') String? fileName,
  }) = _DownloadUrlRecord;

  factory DownloadUrlRecord.fromJson(Map<String, dynamic> json) =>
      _$DownloadUrlRecordFromJson(json);
}
