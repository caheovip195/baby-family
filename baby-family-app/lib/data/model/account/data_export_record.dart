import 'package:baby_family/data/model/account/export_download_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_export_record.freezed.dart';
part 'data_export_record.g.dart';

/// `POST /exports`, `GET /exports/:id` (SET-08).
@Freezed(when: FreezedWhenOptions.none)
abstract class DataExportRecord with _$DataExportRecord {
  @JsonSerializable(explicitToJson: true)
  const factory DataExportRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'scope') String? scope,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'completedAt') DateTime? completedAt,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
    @JsonKey(name: 'errorCode') String? errorCode,
    @JsonKey(name: 'download') ExportDownloadRecord? download,
  }) = _DataExportRecord;

  factory DataExportRecord.fromJson(Map<String, dynamic> json) =>
      _$DataExportRecordFromJson(json);
}
