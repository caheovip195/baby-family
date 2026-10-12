import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_export_job.freezed.dart';
part 'data_export_job.g.dart';

/// Một bản xuất dữ liệu (SET-08).
@Freezed(when: FreezedWhenOptions.none)
abstract class DataExportJob with _$DataExportJob {
  @JsonSerializable(explicitToJson: true)
  const factory DataExportJob({
    @JsonKey(name: 'kind') required DataExportKind kind,
    @JsonKey(name: 'status')
    @Default(DataExportStatus.idle)
    DataExportStatus status,
    @JsonKey(name: 'progress') @Default(0) int progress,
    @JsonKey(name: 'startedAt') DateTime? startedAt,
    @JsonKey(name: 'sizeMb') int? sizeMb,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
  }) = _DataExportJob;

  factory DataExportJob.fromJson(Map<String, dynamic> json) =>
      _$DataExportJobFromJson(json);
}
