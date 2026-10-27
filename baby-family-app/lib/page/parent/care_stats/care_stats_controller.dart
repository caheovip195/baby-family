import 'package:baby_family/data/model/care/care_stats.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-11 — Thống kê chăm con [1.1] (Pencil `EWZwi`, mục 7.15): nhiệm vụ cả
/// nhà đã hoàn thành theo category (mức gia đình, không chia theo người),
/// số ngày cây nở hoa, disclaimer cố định. Bộ chuyển bé dùng chung
/// `selectedSubjectProvider`.
final careStatsControllerProvider =
    ChangeNotifierProvider.autoDispose<CareStatsController>(
      CareStatsController.new,
    );

class CareStatsController extends BaseNotifier {
  CareStatsController(super.ref) {
    today = ref.read(todayProvider);
    subjectId = ref.read(selectedSubjectProvider);
    ref
      ..listen(selectedSubjectProvider, (_, id) {
        subjectId = id;
        load();
      })
      ..listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  ICareService get careService => ref.read(careServiceProvider);

  late DateTime today;
  String? subjectId;

  /// Thứ Hai của tuần đang xem (null = tuần này).
  DateTime? weekStart;

  DateTime get _thisMonday =>
      DateTime(today.year, today.month, today.day - (today.weekday - 1));

  /// Không đi tới tuần sau tuần này.
  bool get canGoNext => weekStart != null && weekStart!.isBefore(_thisMonday);

  void previousWeek() {
    weekStart = (weekStart ?? _thisMonday).subtract(const Duration(days: 7));
    load();
  }

  void nextWeek() {
    if (!canGoNext) {
      return;
    }
    final next = weekStart!.add(const Duration(days: 7));
    weekStart = next.isBefore(_thisMonday) ? next : null;
    load();
  }

  bool loaded = false;
  bool hasError = false;
  CareStats? stats;
  List<Child> children = const [];

  /// Cột cao nhất (để tính chiều cao các cột còn lại).
  int get maxCount => (stats?.categories ?? const []).fold(
    0,
    (max, item) => item.count > max ? item.count : max,
  );

  Future<void> load() async {
    hasError = false;
    try {
      final (value, kids) = await (
        careService.careStats(weekStart: weekStart, childId: subjectId),
        ref.read(childServiceProvider).children(),
      ).wait;
      if (isDisposed) {
        return;
      }
      stats = value;
      children = kids;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void selectSubject(String? childId) =>
      ref.read(selectedSubjectProvider.notifier).select(childId);
}
