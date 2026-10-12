import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// REC-03 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final monthRecapControllerProvider =
    ChangeNotifierProvider.autoDispose<MonthRecapController>(
      MonthRecapController.new,
    );

class MonthRecapController extends BaseNotifier {
  MonthRecapController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
}
