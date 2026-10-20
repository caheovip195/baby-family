/// CARE-03 chuỗi nhiệm vụ lặp lại cho màn quản lý: [weekdays] 1 (thứ Hai)…7;
/// rỗng = hằng ngày; [pausedUntil] ngày cuối đang tạm dừng (nếu có).
class MissionSeriesInfo {
  const MissionSeriesInfo({
    required this.id,
    required this.title,
    this.weekdays = const [],
    this.scheduledTime,
    this.pausedUntil,
    this.canManage = true,
  });

  final String id;
  final String title;
  final List<int> weekdays;
  final String? scheduledTime;
  final DateTime? pausedUntil;

  /// Chuỗi của tôi hoặc “Cùng nhau” (không quản lý chuỗi riêng của bạn đời).
  final bool canManage;
}
