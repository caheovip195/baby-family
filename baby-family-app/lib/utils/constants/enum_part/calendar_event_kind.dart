part of '../enum.dart';

/// Loại mục trên lịch (CARE-07) / loại sự kiện (CAL-02).
enum CalendarEventKind {
  /// Sự kiện của bé.
  child,

  /// Sự kiện gia đình.
  family,

  /// Hẹn hai ta — chỉ Papa & Mama thấy.
  couple,

  /// Nhắc kỷ niệm.
  anniversary,

  /// Ghi chú khám/tiêm.
  health,

  /// Nhiệm vụ trong bảng ngày (lấy từ ICareService).
  mission,
}
