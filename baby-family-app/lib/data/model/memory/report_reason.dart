import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_reason.freezed.dart';
part 'report_reason.g.dart';

/// Lý do báo cáo (RPT-01) — catalog đã dịch.
@Freezed(when: FreezedWhenOptions.none)
abstract class ReportReason with _$ReportReason {
  @JsonSerializable(explicitToJson: true)
  const factory ReportReason({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'hint') String? hint,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'priority') @Default(false) bool priority,
  }) = _ReportReason;

  factory ReportReason.fromJson(Map<String, dynamic> json) =>
      _$ReportReasonFromJson(json);
}
