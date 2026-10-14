import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-17 — Thùng rác: ký ức đã xoá giữ 30 ngày, “Còn N ngày”, Khôi phục /
/// Xoá vĩnh viễn (MEM-17b xác nhận). Bố mẹ thấy mọi ký ức bị xoá trong gia
/// đình; người thân thấy của mình (mục 9.5).
final trashControllerProvider =
    ChangeNotifierProvider.autoDispose<TrashController>(TrashController.new);

class TrashController extends BaseNotifier {
  TrashController(super.ref) {
    load();
  }

  IMemoryService get memoryService => ref.read(memoryServiceProvider);

  List<Memory>? items;
  bool hasError = false;
  bool isParent = true;
  Map<String, String> _callNames = const {};
  Map<String, Child> _children = const {};

  DateTime get today => ref.read(todayProvider);

  int get trashDays => memoryService.trashDays;

  Future<void> load() async {
    hasError = false;
    try {
      final (trash, members, me, children) = await (
        memoryService.trash(),
        ref.read(familyServiceProvider).members(),
        ref.read(familyServiceProvider).me(),
        ref.read(childServiceProvider).children(includeArchived: true),
      ).wait;
      if (isDisposed) {
        return;
      }
      isParent = me?.role.isParent ?? true;
      _callNames = {
        for (final member in members)
          if (member.userId != null) member.userId!: member.callName,
      };
      _children = {for (final child in children) child.id: child};
      items = [
        for (final memory in trash)
          if (isParent || memory.deletedByUserId == me?.userId) memory,
      ];
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  int daysLeft(Memory memory) => memoryService.trashDaysLeft(memory);

  String callNameOf(String? userId) => _callNames[userId] ?? '';

  List<Child> childrenOf(Memory memory) => [
    for (final id in memory.childIds) ?_children[id],
  ];

  Future<void> restore(Memory memory) async {
    await memoryService.restoreMemory(memory.id);
    await load();
  }

  Future<void> deleteForever(Memory memory) async {
    await memoryService.deleteForever(memory.id);
    await load();
  }
}
