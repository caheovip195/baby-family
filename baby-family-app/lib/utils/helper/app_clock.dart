/// Nguồn thời gian duy nhất của tầng dữ liệu, có thể thay trong test.
///
/// Bản mock dùng [AppClock.fixed] bắt đầu từ “hôm nay” của thiết kế Pencil
/// (`kValueDemoStartTime`) rồi chạy theo thời gian thật để hoàn tác 10 giây,
/// “2 phút trước”… vẫn đúng.
class AppClock {
  AppClock.system() : _start = null, _stopwatch = null;

  AppClock.fixed(DateTime start, {bool frozen = false})
    : _start = start,
      _stopwatch = frozen ? null : (Stopwatch()..start());

  final DateTime? _start;
  final Stopwatch? _stopwatch;

  DateTime now() {
    final start = _start;
    if (start == null) {
      return DateTime.now();
    }
    return start.add(_stopwatch?.elapsed ?? Duration.zero);
  }

  /// Ngày hiện tại (00:00).
  DateTime get today {
    final current = now();
    return DateTime(current.year, current.month, current.day);
  }
}
