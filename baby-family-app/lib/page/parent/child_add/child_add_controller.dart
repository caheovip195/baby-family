import 'package:baby_family/data/dto/result.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CHD-04 “Thêm bé” (mục 9.6, Pencil `COfI3`): “Bé đã chào đời” → form như
/// ONB-05b; “Nhà mình đang mong bé” → form thai kỳ như ONB-05a (Thai #N).
/// Không chặn — nút Thêm luôn đi tiếp.
final childAddControllerProvider =
    ChangeNotifierProvider.autoDispose<ChildAddController>(
      ChildAddController.new,
    );

class ChildAddController extends BaseNotifier {
  ChildAddController(super.ref) {
    today = ref.read(todayProvider);
    load();
  }

  IChildService get childService => ref.read(childServiceProvider);

  late DateTime today;
  bool loaded = false;
  bool expecting = false;
  String familyName = '';
  List<Child> children = const [];
  DateTime? date;
  ChildGender gender = ChildGender.unknown;

  /// Số thứ tự thai kỳ mới (Thai #N).
  int get nextPregnancyOrder {
    var order = 0;
    for (final child in children) {
      final value = child.pregnancyOrder ?? 0;
      if (value > order) {
        order = value;
      }
    }
    return order + 1;
  }

  Future<void> load() async {
    final loadedChildren = await childService.children();
    final family = await ref.read(familyServiceProvider).currentFamily();
    if (isDisposed) {
      return;
    }
    children = loadedChildren;
    familyName = family?.name ?? '';
    loaded = true;
    notifyListeners();
  }

  void setExpecting(bool value) {
    expecting = value;
    date = null;
    notifyListeners();
  }

  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  void setGender(ChildGender value) {
    gender = value;
    notifyListeners();
  }

  /// Tạo bé / thai kỳ, trả về hồ sơ mới.
  Future<Child?> submit(String name) async {
    final result = await callFuture(
      expecting
          ? childService.addPregnancy(name: name, dueDate: date)
          : childService.addChild(name: name, birthDate: date, gender: gender),
    );
    return switch (result) {
      Success(:final data) => data,
      Failure() => null,
    };
  }
}
