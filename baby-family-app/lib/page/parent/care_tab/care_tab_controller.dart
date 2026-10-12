import 'package:baby_family/data/dto/care_board.dart';
import 'package:baby_family/data/dto/mission_completion.dart';
import 'package:baby_family/data/model/care/mission.dart';
import 'package:baby_family/data/model/care/mission_template.dart';
import 'package:baby_family/data/model/care/swap_option.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/couple_request.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-01 “Chăm con hôm nay” (+ CARE-05 đổi, CARE-06 hoàn thành, STATE-03).
/// Bảng nhiệm vụ của ngày đang chọn theo chủ thể chung (SW-01), chia 3 tab
/// Của tôi / Của {bạn đời} / Cùng nhau (mục 7.13.7, BR-018/024).
final careTabControllerProvider =
    ChangeNotifierProvider.autoDispose<CareTabController>(
      CareTabController.new,
    );

class CareTabController extends BaseNotifier {
  CareTabController(super.ref) {
    subjectId = ref.read(selectedSubjectProvider);
    today = ref.read(todayProvider);
    selectedDate = today;
    ref
      ..listen(selectedSubjectProvider, (_, id) {
        subjectId = id;
        load();
      })
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  ICareService get careService => ref.read(careServiceProvider);

  /// Số ngày của dải ngày (Pencil `bVndP`: hôm qua + hôm nay + 5 ngày tới).
  static const stripLength = 7;

  late DateTime today;
  late DateTime selectedDate;
  String? subjectId;
  int tabIndex = 0;
  bool hasError = false;

  CareBoard? board;
  List<Child> children = const [];
  Member? me;
  Member? partner;
  List<CoupleRequest> openRequests = const [];
  Set<DateTime> missionDays = const {};

  /// Gợi ý ở STATE-03 (mẫu có mô tả ngắn, hợp tuổi bé đang chọn).
  List<MissionTemplate> suggestions = const [];

  int _loadRevision = 0;
  final Set<String> _busy = {};

  /// Tuần hiện tại từ Thứ Hai đến Chủ nhật (giống CARE-07).
  List<DateTime> get stripDays {
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return [
      for (var index = 0; index < stripLength; index++)
        monday.add(Duration(days: index)),
    ];
  }

  DateTime get now => ref.read(appClockProvider).now();

  bool get isToday => _sameDay(selectedDate, today);

  Child? get subject =>
      children.where((child) => child.id == subjectId).firstOrNull;

  /// Bé nhận gợi ý ở STATE-03: bé đang chọn, hoặc (Cả nhà) bé nhỏ nhất.
  Child? get suggestionChild => _suggestionChild(children);

  Child? _suggestionChild(List<Child> list) {
    final selected = list.where((child) => child.id == subjectId).firstOrNull;
    if (selected != null) {
      return selected;
    }
    final babies =
        list.where((c) => !c.isPregnancy && c.birthDate != null).toList()
          ..sort((a, b) => b.birthDate!.compareTo(a.birthDate!));
    return babies.firstOrNull;
  }

  Child? childOf(Mission mission) => children
      .where((child) => mission.childIds.contains(child.id))
      .firstOrNull;

  String get partnerCallName => partner?.callName ?? '';

  /// Lời nhờ do bạn đời gửi (khác: do tôi gửi).
  bool isFromPartner(CoupleRequest request) =>
      me?.userId == null || request.senderId != me?.userId;

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool hasMissionsOn(DateTime day) =>
      missionDays.any((value) => _sameDay(value, day));

  Future<void> load() async {
    final revision = ++_loadRevision;
    hasError = false;
    if (board == null) {
      toLoading();
    }
    try {
      final familyService = ref.read(familyServiceProvider);
      final loadedBoard = await careService.board(
        date: selectedDate,
        childId: subjectId,
      );
      final loadedChildren = await ref.read(childServiceProvider).children();
      final loadedMe = await familyService.me();
      final loadedPartner = await familyService.partner();
      final requests = await ref
          .read(usServiceProvider)
          .requests(openOnly: true);
      final days = stripDays;
      final loadedDays = await careService.missionDays(days.first, days.last);
      final suggestFor = _suggestionChild(loadedChildren);
      final loadedSuggestions = loadedBoard.isEmpty
          ? (await careService.templates(
              childId: suggestFor?.id,
            )).where((template) => template.hint != null).take(3).toList()
          : const <MissionTemplate>[];
      if (isDisposed || revision != _loadRevision) {
        return;
      }
      board = loadedBoard;
      children = loadedChildren;
      me = loadedMe;
      partner = loadedPartner;
      openRequests = requests;
      missionDays = loadedDays;
      suggestions = loadedSuggestions;
    } catch (_) {
      if (isDisposed || revision != _loadRevision) {
        return;
      }
      hasError = true;
    } finally {
      if (!isDisposed && revision == _loadRevision) {
        toIdle();
        notifyListeners();
      }
    }
  }

  void selectTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  void selectDate(DateTime day) {
    selectedDate = DateTime(day.year, day.month, day.day);
    notifyListeners();
    load();
  }

  void selectSubject(String? childId) =>
      ref.read(selectedSubjectProvider.notifier).select(childId);

  /// Chủ nhiệm vụ (hoặc Cùng nhau) bấm ✓ (BR-024).
  Future<MissionCompletion?> complete(Mission mission) async {
    if (mission.ownerKind == MissionOwnerKind.partner ||
        !_busy.add(mission.id)) {
      return null;
    }
    try {
      return await careService.completeMission(mission.id);
    } catch (_) {
      return null;
    } finally {
      _busy.remove(mission.id);
    }
  }

  Future<void> undo(String missionId) => careService.undoCompletion(missionId);

  Future<void> thank(Mission mission) async {
    if (mission.thankedByPartner || !_busy.add(mission.id)) {
      return;
    }
    try {
      await careService.thankPartner(mission.id);
    } finally {
      _busy.remove(mission.id);
    }
  }

  Future<SwapOption> swapOptions(String missionId) =>
      careService.swapOptions(missionId);

  Future<void> swap(String missionId, String templateId) =>
      careService.swapMission(missionId, templateId);

  Future<void> removeFromToday(String missionId) =>
      careService.removeFromToday(missionId);

  Future<void> saveMoment(String missionId, {String? note}) => careService
      .saveMoment(missionId, note: (note ?? '').trim().isEmpty ? null : note);

  /// STATE-03 “+”: thêm mẫu gợi ý cho bé đang chọn vào hôm nay.
  Future<void> addSuggestion(MissionTemplate template) async {
    if (!_busy.add(template.id)) {
      return;
    }
    try {
      await careService.createMission(
        templateId: template.id,
        childIds: [
          if (template.perChild && suggestionChild != null) suggestionChild!.id,
        ],
        date: selectedDate,
      );
    } finally {
      _busy.remove(template.id);
    }
  }
}
