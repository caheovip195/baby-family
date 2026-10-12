// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportReceipt _$ReportReceiptFromJson(Map<String, dynamic> json) =>
    _ReportReceipt(
      code: json['code'] as String,
      status:
          $enumDecodeNullable(_$ReportStatusEnumMap, json['status']) ??
          ReportStatus.reviewing,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReportReceiptToJson(_ReportReceipt instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': _$ReportStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ReportStatusEnumMap = {
  ReportStatus.reviewing: 'reviewing',
  ReportStatus.resolved: 'resolved',
};
