import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-18 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final draftsControllerProvider =
    ChangeNotifierProvider.autoDispose<DraftsController>(DraftsController.new);

class DraftsController extends BaseNotifier {
  DraftsController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
}
