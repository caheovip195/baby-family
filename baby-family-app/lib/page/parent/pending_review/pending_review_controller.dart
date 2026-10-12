import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-19 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final pendingReviewControllerProvider =
    ChangeNotifierProvider.autoDispose<PendingReviewController>(
      PendingReviewController.new,
    );

class PendingReviewController extends BaseNotifier {
  PendingReviewController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
}
