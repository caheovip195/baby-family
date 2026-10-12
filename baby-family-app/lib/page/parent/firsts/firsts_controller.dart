import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/milestone_item.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-12 Những lần đầu (không có trong Pencil — tài liệu 9.4): lưới cột mốc
/// đã có (ảnh + ngày + tuổi) / chưa có (mờ, chạm → ghi).
final firstsControllerProvider =
    ChangeNotifierProvider.autoDispose<FirstsController>(FirstsController.new);

class FirstsController extends BaseNotifier {
  FirstsController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
  }

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);

  String? childId;
  bool loaded = false;
  bool hideMissing = false;
  List<Child> children = const [];
  List<MilestoneItem> items = const [];

  DateTime get today => childService.today;
  Child? get child =>
      children.where((value) => value.id == childId).firstOrNull;

  List<MilestoneItem> get visible => hideMissing
      ? items.where((item) => item.achievedAt != null).toList()
      : items;

  Future<void> init(String id) async {
    childId = id;
    await load();
  }

  Future<void> load() async {
    final id = childId;
    if (id == null) {
      return;
    }
    final (kids, milestones) = await (
      childService.children(),
      memoryService.milestones(id),
    ).wait;
    if (isDisposed) {
      return;
    }
    children = kids;
    // Đã có trước (mới nhất trước), rồi tới cột mốc chưa có.
    items = [
      ...milestones.where((item) => item.achievedAt != null).toList()
        ..sort((a, b) => b.achievedAt!.compareTo(a.achievedAt!)),
      ...milestones.where((item) => item.achievedAt == null),
    ];
    loaded = true;
    notifyListeners();
  }

  void selectChild(String? id) {
    if (id == null || id == childId) {
      return;
    }
    childId = id;
    load();
  }

  void toggleHideMissing(bool value) {
    hideMissing = value;
    notifyListeners();
  }
}
