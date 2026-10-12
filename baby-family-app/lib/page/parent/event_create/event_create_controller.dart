import 'package:baby_family/data/model/care/calendar_event.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/lunar_date.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CAL-02 “Tạo sự kiện” (mục 9.7, Pencil `xlxDc`): tiêu đề, loại, ngày (công
/// tắc âm lịch), lặp hằng năm, cả ngày/giờ, bé liên quan, người tham gia
/// (“Mời cả nhà” — gói Family), nhắc, ghi chú. Điền sẵn bản nháp mẫu; Lưu
/// luôn đi tiếp (UI-first).
final eventCreateControllerProvider =
    ChangeNotifierProvider.autoDispose<EventCreateController>(
      EventCreateController.new,
    );

/// Các lựa chọn nhắc có thể thêm (mã khớp `calendarReminder`).
const kEventReminderCodes = [
  'dayBefore0900',
  'morning',
  'atTime',
  'hourBefore',
  'weekBefore',
];

class EventCreateController extends BaseNotifier {
  EventCreateController(super.ref) {
    today = ref.read(todayProvider);
  }

  ICareService get careService => ref.read(careServiceProvider);

  late DateTime today;
  bool loaded = false;
  List<Child> children = const [];
  Member? me;
  Member? partner;
  late CalendarEvent event;

  /// Loại hiển thị trên form (CAL-02 không có “Nhiệm vụ”).
  static const kinds = [
    CalendarEventKind.child,
    CalendarEventKind.family,
    CalendarEventKind.couple,
    CalendarEventKind.anniversary,
    CalendarEventKind.health,
  ];

  ({int day, int month, int year, bool leap}) get lunarDate =>
      solarToLunar(event.date);

  Future<void> init() async {
    final draft = await careService.eventDraft();
    final loadedChildren = await ref.read(childServiceProvider).children();
    final family = ref.read(familyServiceProvider);
    final loadedMe = await family.me();
    final loadedPartner = await family.partner();
    if (isDisposed) {
      return;
    }
    event = draft;
    children = loadedChildren;
    me = loadedMe;
    partner = loadedPartner;
    loaded = true;
    notifyListeners();
  }

  void _update(CalendarEvent value) {
    event = value;
    notifyListeners();
  }

  void setTitle(String value) => event = event.copyWith(title: value);

  void setKind(CalendarEventKind kind) => _update(event.copyWith(kind: kind));

  void setLunar(bool value) => _update(event.copyWith(lunar: value));

  void setDate(DateTime date) {
    final lunar = solarToLunar(date);
    _update(
      event.copyWith(date: date, lunarDay: lunar.day, lunarMonth: lunar.month),
    );
  }

  void setRepeatYearly(bool value) =>
      _update(event.copyWith(repeatYearly: value));

  void setAllDay(bool value) => _update(event.copyWith(allDay: value));

  void setTime(String value) => _update(event.copyWith(time: value));

  void toggleChild(String id) {
    final ids = [...event.childIds];
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    _update(event.copyWith(childIds: ids));
  }

  void toggleParticipant(String userId) {
    final ids = [...event.participantUserIds];
    ids.contains(userId) ? ids.remove(userId) : ids.add(userId);
    _update(event.copyWith(participantUserIds: ids));
  }

  void setInviteFamily(bool value) =>
      _update(event.copyWith(inviteFamily: value));

  void toggleReminder(String code) {
    final codes = [...event.reminders];
    codes.contains(code) ? codes.remove(code) : codes.add(code);
    _update(event.copyWith(reminders: codes));
  }

  /// “+ Thêm”: thêm lựa chọn nhắc kế tiếp chưa có.
  void addReminder() {
    for (final code in kEventReminderCodes) {
      if (!event.reminders.contains(code)) {
        toggleReminder(code);
        return;
      }
    }
  }

  Future<bool> save() async {
    final result = await callFuture(careService.createEvent(event));
    return result.isSuccess;
  }
}
