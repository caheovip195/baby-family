import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_download_record.freezed.dart';
part 'export_download_record.g.dart';

/// Link tải bản xuất, hết hạn sau ~15 phút.
@Freezed(when: FreezedWhenOptions.none)
abstract class ExportDownloadRecord with _$ExportDownloadRecord {
  @JsonSerializable(explicitToJson: true)
  const factory ExportDownloadRecord({
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
  }) = _ExportDownloadRecord;

  factory ExportDownloadRecord.fromJson(Map<String, dynamic> json) =>
      _$ExportDownloadRecordFromJson(json);
}
