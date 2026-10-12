import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_receipt.freezed.dart';
part 'report_receipt.g.dart';

/// Biên nhận báo cáo (RPT-01b).
@Freezed(when: FreezedWhenOptions.none)
abstract class ReportReceipt with _$ReportReceipt {
  @JsonSerializable(explicitToJson: true)
  const factory ReportReceipt({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'status')
    @Default(ReportStatus.reviewing)
    ReportStatus status,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
  }) = _ReportReceipt;

  factory ReportReceipt.fromJson(Map<String, dynamic> json) =>
      _$ReportReceiptFromJson(json);
}
