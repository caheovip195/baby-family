import 'package:baby_family/data/model/care/mission_history_day.dart';
import 'package:baby_family/data/model/care/mission_history_entry.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-08 “Lịch sử” (mục 9.7, Pencil `LxWjt`): theo ngày — việc của tôi (đã
/// xong / không kịp làm, màu trung tính) + Cùng nhau; việc của bạn đời chỉ
/// hiện khi đã xong (✓, không Hearts — BR-018). Lọc theo bé / loại.
final missionHistoryControllerProvider =
    ChangeNotifierProvider.autoDispose<MissionHistoryController>(
      MissionHistoryController.new,
    );

class MissionHistoryController extends BaseNotifier {
  MissionHistoryController(super.ref) {
    today = ref.read(todayProvider);
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  ICareService get careService => ref.read(careServiceProvider);

  late DateTime today;
  bool loaded = false;
  bool hasError = false;
  List<MissionHistoryDay> _days = const [];
  List<Child> children = const [];
  Member? me;
  Member? partner;
  String? childId;
  String? category;

  String get partnerCallName => partner?.callName ?? '';

  /// Bé thật để lọc (không gồm thai kỳ).
  List<Child> get babies => [
    for (final child in children)
      if (!child.isPregnancy) child,
  ];

  /// Loại có trong lịch sử (theo thứ tự xuất hiện).
  List<String> get categories => {
    for (final day in _days)
      for (final entry in day.entries) ?entry.categoryCode,
  }.toList();

  bool _matches(MissionHistoryEntry entry) =>
      (childId == null || entry.childIds.contains(childId)) &&
      (category == null || entry.categoryCode == category);

  List<MissionHistoryDay> get days => [
    for (final day in _days)
      if (day.entries.any(_matches))
        day.copyWith(entries: day.entries.where(_matches).toList()),
  ];

  Child? child(String id) {
    for (final child in children) {
      if (child.id == id) {
        return child;
      }
    }
    return null;
  }

  Future<void> load() async {
    hasError = false;
    try {
      final history = await careService.missionHistory();
      final loadedChildren = await ref.read(childServiceProvider).children();
      final family = ref.read(familyServiceProvider);
      final loadedMe = await family.me();
      final loadedPartner = await family.partner();
      if (isDisposed) {
        return;
      }
      _days = history;
      children = loadedChildren;
      me = loadedMe;
      partner = loadedPartner;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void selectChild(String? id) {
    childId = id;
    notifyListeners();
  }

  void selectCategory(String? code) {
    category = code;
    notifyListeners();
  }
}
