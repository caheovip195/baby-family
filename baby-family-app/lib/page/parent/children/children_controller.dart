import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CHD-03 “Các con” (mục 9.6, Pencil `Dcj0x`): danh sách bé + thai kỳ (giữ và
/// kéo để sắp xếp thứ tự hiển thị), mục đã lưu trữ (khôi phục), “+ Thêm bé”.
final childrenControllerProvider =
    ChangeNotifierProvider.autoDispose<ChildrenController>(
      ChildrenController.new,
    );

class ChildrenController extends BaseNotifier {
  ChildrenController(super.ref) {
    today = ref.read(todayProvider);
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  IChildService get childService => ref.read(childServiceProvider);

  late DateTime today;
  bool loaded = false;
  bool hasError = false;
  bool archivedExpanded = true;
  List<Child> children = const [];
  List<Child> archived = const [];

  /// Số ký ức riêng của bé đã lưu trữ (CHD-05: bị ẩn khi lưu trữ).
  Map<String, int> privateMemories = const {};

  Future<void> load() async {
    hasError = false;
    try {
      final loadedChildren = await childService.children();
      final loadedArchived = await childService.archivedChildren();
      final counts = <String, int>{
        for (final child in loadedArchived)
          child.id:
              (await childService.profile(child.id))?.privateMemoryCount ?? 0,
      };
      if (isDisposed) {
        return;
      }
      children = loadedChildren;
      archived = loadedArchived;
      privateMemories = counts;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  /// [newIndex] đã tính sau khi bỏ mục cũ (`onReorderItem`).
  Future<void> reorder(int oldIndex, int newIndex) async {
    final list = [...children];
    final moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);
    children = list;
    notifyListeners();
    await childService.reorderChildren([for (final child in list) child.id]);
  }

  void toggleArchived() {
    archivedExpanded = !archivedExpanded;
    notifyListeners();
  }

  Future<void> restore(String childId) async {
    await childService.restoreChild(childId);
    await load();
  }
}
