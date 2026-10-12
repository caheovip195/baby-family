import 'package:baby_family/data/dto/pregnancy_timeline_week.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/bump_photo.dart';
import 'package:baby_family/data/model/memory/child_memory_stats.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/pregnancy/prep_summary.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/pregnancy.dart';
import 'package:baby_family/data/service/pregnancy.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:hooks_riverpod/legacy.dart';

/// PREG-01…04 — Hành trình thai kỳ: header tuần thai, 4 tab Dòng thời gian /
/// Bụng bầu / Siêu âm / Chuẩn bị (mục 9.5), menu Sửa / Lưu trữ / Bé đã chào
/// đời.
final pregnancyJourneyControllerProvider =
    ChangeNotifierProvider.autoDispose<PregnancyJourneyController>(
      PregnancyJourneyController.new,
    );

class PregnancyJourneyController extends BaseNotifier {
  PregnancyJourneyController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
  }

  IPregnancyService get pregnancyService => ref.read(pregnancyServiceProvider);

  String? _pregnancyId;
  PregnancyTab tab = PregnancyTab.timeline;
  Child? child;
  ChildMemoryStats? stats;
  List<Memory> memories = const [];
  List<BumpPhoto> bumpPhotos = const [];
  PrepSummary? prep;
  List<Member> members = const [];
  Member? partner;
  bool hasError = false;

  /// “Nhắc chụp mỗi Chủ nhật” (PREG-02) — bật mặc định như thiết kế.
  bool remindBump = true;
  int _revision = 0;

  DateTime get today => ref.read(todayProvider);

  bool get isLoaded => child != null;

  ({int week, int day})? get week {
    final due = child?.dueDate;
    return due == null ? null : pregnancyWeek(due, today);
  }

  int? get daysLeft {
    final due = child?.dueDate;
    return due == null ? null : daysUntil(due, today);
  }

  String get partnerCallName => partner?.callName ?? '';

  String? callNameOf(String? userId) =>
      members.where((member) => member.userId == userId).firstOrNull?.callName;

  /// Nhận `pregnancyId` + tab ban đầu (query `tab`) từ route.
  void init(String pregnancyId, String? tabName) {
    if (_pregnancyId == pregnancyId) {
      return;
    }
    _pregnancyId = pregnancyId;
    tab = PregnancyTab.fromName(tabName);
    load();
  }

  void selectTab(PregnancyTab value) {
    if (tab == value) {
      return;
    }
    tab = value;
    notifyListeners();
  }

  Future<void> load() async {
    final pregnancyId = _pregnancyId;
    if (pregnancyId == null) {
      return;
    }
    final revision = ++_revision;
    final firstLoad = child == null;
    if (firstLoad) {
      toLoading();
    }
    try {
      final childService = ref.read(childServiceProvider);
      final memoryService = ref.read(memoryServiceProvider);
      final family = ref.read(familyServiceProvider);
      final results = await Future.wait<Object?>([
        childService.child(pregnancyId),
        childService.stats(pregnancyId),
        memoryService.memories(childId: pregnancyId),
        memoryService.bumpPhotos(pregnancyId),
        pregnancyService.prep(pregnancyId),
        family.members(),
        family.partner(),
      ]);
      if (isDisposed || revision != _revision) {
        return;
      }
      child = results[0] as Child?;
      stats = results[1] as ChildMemoryStats?;
      memories = results[2]! as List<Memory>;
      bumpPhotos = results[3]! as List<BumpPhoto>;
      prep = results[4] as PrepSummary?;
      members = results[5]! as List<Member>;
      partner = results[6] as Member?;
      hasError = child == null;
    } catch (_) {
      if (isDisposed || revision != _revision) {
        return;
      }
      hasError = true;
    }
    if (firstLoad) {
      toIdle();
    }
    notifyListeners();
  }

  /// Dòng thời gian theo tuần, mới nhất trước. Tuần hiện tại luôn có (ô chụp
  /// ảnh bụng); tuần chỉ có ảnh bụng không hiện (xem tab Bụng bầu).
  List<PregnancyTimelineWeek> get timeline {
    final current = week?.week;
    final byWeek = <int, List<Memory>>{};
    for (final memory in memories) {
      final value = memory.pregnancyWeek;
      if (value != null) {
        byWeek.putIfAbsent(value, () => []).add(memory);
      }
    }
    if (current != null) {
      byWeek.putIfAbsent(current, () => []);
    }
    final weeks = byWeek.keys.toList()..sort((a, b) => b.compareTo(a));
    final bumpWeeks = {for (final photo in bumpPhotos) photo.week};
    final ghost = bumpPhotos
        .where((photo) => current == null || photo.week < current)
        .map((photo) => photo.week)
        .fold<int?>(
          null,
          (max, value) => max == null || value > max ? value : max,
        );
    return [
      for (final value in weeks)
        if (value == current ||
            byWeek[value]!.any((memory) => memory.kind != MemoryKind.bump))
          PregnancyTimelineWeek(
            week: value,
            isCurrent: value == current,
            memoryCount: byWeek[value]!.length,
            hasFirst: byWeek[value]!.any(
              (memory) => memory.kind == MemoryKind.milestone,
            ),
            items: byWeek[value]!
                .where((memory) => memory.kind != MemoryKind.bump)
                .toList(),
            bumpSlot: value == current && !bumpWeeks.contains(value),
            ghostWeek: value == current ? ghost : null,
          ),
    ];
  }

  /// Ảnh siêu âm theo tuần (PREG-03), mới nhất trước.
  List<Memory> get ultrasounds =>
      memories.where((memory) => memory.kind == MemoryKind.ultrasound).toList()
        ..sort(
          (a, b) => (b.pregnancyWeek ?? 0).compareTo(a.pregnancyWeek ?? 0),
        );

  /// Ô lưới PREG-02: từ tuần ảnh bụng đầu tiên tới tuần hiện tại.
  List<int> get bumpGridWeeks {
    final current = week?.week;
    if (bumpPhotos.isEmpty) {
      return current == null ? const [] : [current];
    }
    final first = bumpPhotos.first.week;
    final last = current ?? bumpPhotos.last.week;
    return [for (var value = first; value <= last; value++) value];
  }

  BumpPhoto? bumpOf(int week) =>
      bumpPhotos.where((photo) => photo.week == week).firstOrNull;

  /// So sánh mặc định: ảnh mới nhất với ảnh cách đó khoảng 7 tuần (hoặc ảnh
  /// đầu tiên).
  (BumpPhoto, BumpPhoto)? get bumpCompare {
    if (bumpPhotos.length < 2) {
      return null;
    }
    final latest = bumpPhotos.last;
    final target = latest.week - kValueBumpCompareWeeks;
    final earlier = bumpPhotos.lastWhere(
      (photo) => photo.week <= target,
      orElse: () => bumpPhotos.first,
    );
    return (earlier, latest);
  }

  void toggleRemindBump(bool value) {
    remindBump = value;
    notifyListeners();
  }

  Future<void> togglePrep(String itemId) async {
    await pregnancyService.togglePrep(itemId);
  }

  Future<void> setPrepOwner(String itemId, MissionOwnerKind owner) async {
    await pregnancyService.setPrepOwner(itemId, owner);
  }

  Future<void> addPrep(String title, PrepGroup group) async {
    final pregnancyId = _pregnancyId;
    if (pregnancyId == null || title.trim().isEmpty) {
      return;
    }
    await pregnancyService.addPrep(pregnancyId, title: title, group: group);
  }

  /// Sửa thai kỳ: tên ở nhà + ngày dự sinh.
  Future<void> saveEdit({required String name, DateTime? dueDate}) async {
    final current = child;
    if (current == null) {
      return;
    }
    await ref
        .read(childServiceProvider)
        .updateChild(
          current.copyWith(
            name: name.trim().isEmpty ? current.name : name.trim(),
            dueDate: dueDate ?? current.dueDate,
          ),
        );
  }
}
