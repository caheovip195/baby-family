import 'package:baby_family/data/model/settings/data_export_job.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_export_info.freezed.dart';
part 'data_export_info.g.dart';

/// Dữ liệu của tôi (SET-08).
@Freezed(when: FreezedWhenOptions.none)
abstract class DataExportInfo with _$DataExportInfo {
  @JsonSerializable(explicitToJson: true)
  const factory DataExportInfo({
    @JsonKey(name: 'jobs') @Default([]) List<DataExportJob> jobs,
    @JsonKey(name: 'cacheMb') @Default(0) int cacheMb,
  }) = _DataExportInfo;

  factory DataExportInfo.fromJson(Map<String, dynamic> json) =>
      _$DataExportInfoFromJson(json);
}
