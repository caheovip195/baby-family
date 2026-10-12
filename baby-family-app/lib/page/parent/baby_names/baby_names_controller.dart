import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/pregnancy/name_candidate.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/pregnancy.dart';
import 'package:baby_family/data/service/pregnancy.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// PREG-07 — Đặt tên cho con (chỉ Papa & Mama): tên + ý nghĩa + ai thêm, tim
/// của từng người, “Cả hai thích”, “Chọn … làm tên” → cột mốc “Chọn được tên”.
final babyNamesControllerProvider =
    ChangeNotifierProvider.autoDispose<BabyNamesController>(
      BabyNamesController.new,
    );

class BabyNamesController extends BaseNotifier {
  BabyNamesController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
  }

  IPregnancyService get pregnancyService => ref.read(pregnancyServiceProvider);

  String? _pregnancyId;
  Child? child;
  Member? me;
  List<NameCandidate> names = const [];
  String? selectedId;
  bool hasError = false;
  int _revision = 0;

  bool get isLoaded => child != null;

  /// Tôi là Mama → vòng “M” là tim của tôi; ngược lại vòng “P”.
  bool get iAmMama => me?.role != FamilyRole.father;

  NameCandidate? get selected =>
      names.where((name) => name.id == selectedId).firstOrNull;

  void init(String pregnancyId) {
    if (_pregnancyId == pregnancyId) {
      return;
    }
    _pregnancyId = pregnancyId;
    load();
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
      final results = await Future.wait<Object?>([
        ref.read(childServiceProvider).child(pregnancyId),
        ref.read(familyServiceProvider).me(),
        pregnancyService.names(pregnancyId),
      ]);
      if (isDisposed || revision != _revision) {
        return;
      }
      child = results[0] as Child?;
      me = results[1] as Member?;
      final loaded = results[2]! as List<NameCandidate>;
      // Tên cả hai cùng thích nổi lên đầu (7.5).
      names = [
        ...loaded.where((name) => name.bothLike),
        ...loaded.where((name) => !name.bothLike),
      ];
      if (selected == null) {
        selectedId =
            (names.where((name) => name.chosen).firstOrNull ??
                    names.where((name) => name.bothLike).firstOrNull ??
                    names.firstOrNull)
                ?.id;
      }
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

  void select(String nameId) {
    selectedId = nameId;
    notifyListeners();
  }

  Future<void> toggleLike(String nameId) =>
      pregnancyService.toggleNameLike(nameId);

  Future<void> addName(String name, String meaning) async {
    final pregnancyId = _pregnancyId;
    if (pregnancyId == null || name.trim().isEmpty) {
      return;
    }
    await pregnancyService.addName(
      pregnancyId,
      name: name,
      meaning: meaning.trim().isEmpty ? null : meaning.trim(),
    );
  }

  Future<void> chooseSelected() async {
    final id = selectedId;
    if (id == null) {
      return;
    }
    await whileLoading(() => pregnancyService.chooseName(id));
  }
}
