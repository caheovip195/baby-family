import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// REC-01 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final dayStoryControllerProvider =
    ChangeNotifierProvider.autoDispose<DayStoryController>(
      DayStoryController.new,
    );

class DayStoryController extends BaseNotifier {
  DayStoryController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
}
