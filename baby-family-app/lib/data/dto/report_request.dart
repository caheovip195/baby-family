/// RPT-01 — lựa chọn của người báo cáo, gửi qua `IMemoryService.submitReport`.
class ReportRequest {
  const ReportRequest({
    required this.reasonCode,
    this.note,
    this.hideForMe = false,
    this.removeFromFamily = false,
  });

  final String reasonCode;
  final String? note;
  final bool hideForMe;
  final bool removeFromFamily;
}
