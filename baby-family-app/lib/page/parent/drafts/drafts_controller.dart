import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/memory_draft_item.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-18 — Nháp: nháp trên máy trước, nháp đã lưu trên tài khoản sau;
/// “Tiếp tục soạn” mở lại trình soạn theo loại, “Xoá” bỏ nháp. Chỉ mình
/// người soạn thấy nháp.
final draftsControllerProvider =
    ChangeNotifierProvider.autoDispose<DraftsController>(DraftsController.new);

class DraftsController extends BaseNotifier {
  DraftsController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  IMemoryService get memoryService => ref.read(memoryServiceProvider);

  List<MemoryDraftItem>? drafts;
  bool hasError = false;
  Map<String, Child> _children = const {};

  DateTime get today => ref.read(todayProvider);

  List<MemoryDraftItem> get onDevice => [
    for (final draft in drafts ?? const <MemoryDraftItem>[])
      if (draft.location == DraftLocation.device) draft,
  ];

  List<MemoryDraftItem> get inCloud => [
    for (final draft in drafts ?? const <MemoryDraftItem>[])
      if (draft.location == DraftLocation.cloud) draft,
  ];

  Future<void> load() async {
    hasError = false;
    try {
      final (items, children) = await (
        memoryService.drafts(),
        ref.read(childServiceProvider).children(),
      ).wait;
      if (isDisposed) {
        return;
      }
      drafts = items;
      _children = {for (final child in children) child.id: child};
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  String childNames(MemoryDraftItem draft) =>
      [for (final id in draft.childIds) ?_children[id]?.name].join(', ');

  Future<void> delete(MemoryDraftItem draft) async {
    await memoryService.deleteDraft(draft.id);
    await load();
  }
}
