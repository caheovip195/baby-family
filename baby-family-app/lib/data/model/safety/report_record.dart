import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_record.freezed.dart';
part 'report_record.g.dart';

/// `POST /v1/reports` → mã tham chiếu cho RPT-01b.
@Freezed(when: FreezedWhenOptions.none)
abstract class ReportRecord with _$ReportRecord {
  @JsonSerializable(explicitToJson: true)
  const factory ReportRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _ReportRecord;

  factory ReportRecord.fromJson(Map<String, dynamic> json) =>
      _$ReportRecordFromJson(json);
}
