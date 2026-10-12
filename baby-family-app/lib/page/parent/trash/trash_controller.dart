import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-17 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final trashControllerProvider =
    ChangeNotifierProvider.autoDispose<TrashController>(TrashController.new);

class TrashController extends BaseNotifier {
  TrashController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
}
