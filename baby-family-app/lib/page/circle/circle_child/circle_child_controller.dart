import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/circle.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CIR-02 — Trang của cháu (người thân, chữ lớn): đầu trang cháu (tuổi,
/// “Ngày mai tròn N tháng”), Những lần đầu (chỉ xem), ký ức theo tháng tuổi
/// — chỉ nội dung được chia sẻ, không có nhiệm vụ.
final circleChildControllerProvider =
    ChangeNotifierProvider.autoDispose<CircleChildController>(
      CircleChildController.new,
    );

class CircleChildController extends BaseNotifier {
  CircleChildController(super.ref) {
    ref.listen(circleSelectedChildProvider, (_, _) => load());
    Future.microtask(load);
  }

  ICircleService get circleService => ref.read(circleServiceProvider);

  CircleView? view;
  Child? child;
  List<Memory> firsts = const [];
  bool hasError = false;
  Map<String, String> _authorNames = const {};

  DateTime get now => ref.read(appClockProvider).now();

  DateTime get today => ref.read(appClockProvider).today;

  Future<void> load() async {
    hasError = false;
    toLoading();
    try {
      final (loaded, members) = await (
        circleService.view(),
        ref.read(familyServiceProvider).members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      view = loaded;
      _authorNames = {
        for (final member in members)
          if (member.userId != null) member.userId!: member.callName,
      };
      final babies = [
        for (final kid in loaded?.children ?? const <Child>[])
          if (kid.birthDate != null) kid,
      ];
      final selectedId = ref.read(circleSelectedChildProvider);
      child =
          babies.where((kid) => kid.id == selectedId).firstOrNull ??
          ([
            ...babies,
          ]..sort((a, b) => b.birthDate!.compareTo(a.birthDate!))).firstOrNull;
      final current = child;
      firsts = current == null
          ? const []
          : await circleService.firsts(current.id);
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    toIdle();
  }

  String authorName(String userId) => _authorNames[userId] ?? '';

  /// Tròn tháng vào ngày mai → số tháng (CIR-02 “🎉 Ngày mai tròn 18 tháng”).
  int? get monthsTomorrow {
    final birth = child?.birthDate;
    if (birth == null) {
      return null;
    }
    final tomorrow = today.add(const Duration(days: 1));
    final months = childAgeInMonths(birth, tomorrow);
    return months > childAgeInMonths(birth, today) ? months : null;
  }

  /// Ký ức của cháu theo tháng tuổi, tháng gần nhất trước (lần đầu hiện ở
  /// mục riêng).
  List<(int, List<Memory>)> get months {
    final current = child;
    final birth = current?.birthDate;
    if (current == null || birth == null) {
      return const [];
    }
    final groups = <int, List<Memory>>{};
    for (final memory in view?.memories ?? const <Memory>[]) {
      if (!memory.childIds.contains(current.id) ||
          memory.kind == MemoryKind.milestone) {
        continue;
      }
      groups
          .putIfAbsent(childMonthIndex(birth, memory.occurredAt), () => [])
          .add(memory);
    }
    final keys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    return [for (final key in keys) (key, groups[key]!)];
  }
}
