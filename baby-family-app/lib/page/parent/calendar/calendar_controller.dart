import 'package:baby_family/data/model/care/calendar_event.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-07 “Lịch” (mục 9.7, Pencil `DRYZP`): chế độ Tuần (mặc định) / Tháng,
/// chấm màu theo loại (nhiệm vụ / sự kiện / hẹn hai ta), ngày âm lịch nhỏ dưới
/// ngày dương (bật/tắt — `appLunarDateProvider`), chạm ngày → danh sách.
final calendarControllerProvider =
    ChangeNotifierProvider.autoDispose<CalendarController>(
      CalendarController.new,
    );

/// Loại chấm của một ngày (Pencil “Dots”: `primary-500` / `accent-500` /
/// `us-500`).
enum CalendarDot { mission, event, couple }

class CalendarController extends BaseNotifier {
  CalendarController(super.ref) {
    today = ref.read(todayProvider);
    selectedDay = today;
    month = DateTime(today.year, today.month);
    subjectId = ref.read(selectedSubjectProvider);
    ref
      ..listen(appLunarDateProvider, (_, _) => notifyListeners())
      ..listen(selectedSubjectProvider, (_, id) {
        subjectId = id;
        notifyListeners();
      })
      ..listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  ICareService get careService => ref.read(careServiceProvider);

  late DateTime today;
  late DateTime selectedDay;

  /// Tháng đang xem (ngày 1).
  late DateTime month;
  String? subjectId;
  bool monthMode = false;
  bool loaded = false;
  bool hasError = false;
  List<CalendarEvent> _events = const [];
  List<Child> children = const [];
  Member? partner;

  bool get showLunar => ref.read(appLunarDateProvider);

  String get partnerCallName => partner?.callName ?? '';

  /// Tuần (Thứ Hai → Chủ Nhật) chứa ngày đang chọn.
  List<DateTime> get weekDays {
    final start = selectedDay.subtract(Duration(days: selectedDay.weekday - 1));
    return [
      for (var i = 0; i < 7; i++)
        DateTime(start.year, start.month, start.day + i),
    ];
  }

  /// Lưới tháng: các tuần đủ 7 ngày phủ [month] (ngày ngoài tháng = null).
  List<DateTime?> get monthCells {
    final first = month;
    final daysInMonth = DateTime(first.year, first.month + 1, 0).day;
    final lead = first.weekday - 1;
    final total = ((lead + daysInMonth) / 7).ceil() * 7;
    return [
      for (var i = 0; i < total; i++)
        i < lead || i >= lead + daysInMonth
            ? null
            : DateTime(first.year, first.month, i - lead + 1),
    ];
  }

  Future<void> load() async {
    hasError = false;
    try {
      final from = DateTime(month.year, month.month - 1, 20);
      final to = DateTime(month.year, month.month + 1, 10);
      final events = await careService.calendarEvents(from, to);
      final loadedChildren = await ref.read(childServiceProvider).children();
      final loadedPartner = await ref.read(familyServiceProvider).partner();
      if (isDisposed) {
        return;
      }
      _events = events;
      children = loadedChildren;
      partner = loadedPartner;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _visible(CalendarEvent event) =>
      subjectId == null ||
      event.childIds.isEmpty ||
      event.childIds.contains(subjectId);

  /// Mục của một ngày theo bé đang chọn (cả ngày trước, rồi theo giờ).
  List<CalendarEvent> eventsOn(DateTime day) => [
    for (final event in _events)
      if (_sameDay(event.date, day) && _visible(event)) event,
  ];

  List<CalendarEvent> get selectedEvents => eventsOn(selectedDay);

  /// Chấm của ngày: bảng nhiệm vụ được gợi ý mỗi ngày (mục 7.13.2) nên luôn
  /// có chấm nhiệm vụ; thêm chấm sự kiện / hẹn hai ta theo dữ liệu lịch.
  List<CalendarDot> dotsOn(DateTime day) {
    final events = eventsOn(day);
    return [
      CalendarDot.mission,
      if (events.any(
        (event) =>
            event.kind != CalendarEventKind.mission &&
            event.kind != CalendarEventKind.couple,
      ))
        CalendarDot.event,
      if (events.any((event) => event.kind == CalendarEventKind.couple))
        CalendarDot.couple,
    ];
  }

  bool isToday(DateTime day) => _sameDay(day, today);

  bool isSelected(DateTime day) => _sameDay(day, selectedDay);

  Child? child(String id) {
    for (final child in children) {
      if (child.id == id) {
        return child;
      }
    }
    return null;
  }

  void selectDay(DateTime day) {
    selectedDay = day;
    final dayMonth = DateTime(day.year, day.month);
    if (dayMonth != month) {
      month = dayMonth;
      load();
    }
    notifyListeners();
  }

  void setMonthMode(bool value) {
    monthMode = value;
    notifyListeners();
  }

  /// Mũi tên tháng: Tuần → lùi/tiến 1 tuần; Tháng → lùi/tiến 1 tháng.
  void shift(int step) {
    if (monthMode) {
      month = DateTime(month.year, month.month + step);
      final days = DateTime(month.year, month.month + 1, 0).day;
      selectedDay = DateTime(
        month.year,
        month.month,
        selectedDay.day > days ? days : selectedDay.day,
      );
      load();
      notifyListeners();
    } else {
      selectDay(selectedDay.add(Duration(days: 7 * step)));
    }
  }

  void setLunar(bool value) =>
      ref.read(appLunarDateProvider.notifier).change(value);

  void selectSubject(String? childId) =>
      ref.read(selectedSubjectProvider.notifier).select(childId);
}
