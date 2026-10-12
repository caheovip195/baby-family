part of '../enum.dart';

/// Mục của sheet tạo nhanh QC-01 (Pencil IWfKB), theo thứ tự hiển thị.
enum QuickCreateAction {
  memory,
  diary,
  milestone,
  letter,
  mission,
  event,
  checkin,
  request,
  thanks;

  /// Mục thuộc vùng riêng Papa & Mama (nền tím).
  bool get isCouple =>
      this == QuickCreateAction.checkin ||
      this == QuickCreateAction.request ||
      this == QuickCreateAction.thanks;
}
