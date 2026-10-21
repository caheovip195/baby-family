/// Thẻ tổng kết tuần trên dòng thời gian (mở màn Recap tuần).
class RecapWeekEntry {
  const RecapWeekEntry(this.weekStart);

  /// Ngày đầu tuần (theo giờ gia đình).
  final DateTime weekStart;

  DateTime get weekEnd => weekStart.add(const Duration(days: 6));
}
