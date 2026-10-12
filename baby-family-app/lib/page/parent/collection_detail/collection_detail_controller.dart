import 'package:baby_family/data/model/memory/collection_summary.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// Chi tiết bộ sưu tập (MEM-22 → không có trong Pencil): lưới ký ức.
final collectionDetailControllerProvider =
    ChangeNotifierProvider.autoDispose<CollectionDetailController>(
      CollectionDetailController.new,
    );

class CollectionDetailController extends BaseNotifier {
  CollectionDetailController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
  }

  IMemoryService get memoryService => ref.read(memoryServiceProvider);

  String? code;
  bool loaded = false;
  CollectionSummary? summary;
  List<Memory> memories = const [];

  Future<void> init(String value) async {
    code = value;
    await load();
  }

  Future<void> load() async {
    final value = code;
    if (value == null) {
      return;
    }
    final (collections, items) = await (
      memoryService.collections(),
      memoryService.collectionMemories(value),
    ).wait;
    if (isDisposed) {
      return;
    }
    summary = collections.where((item) => item.code == value).firstOrNull;
    memories = items;
    loaded = true;
    notifyListeners();
  }
}
