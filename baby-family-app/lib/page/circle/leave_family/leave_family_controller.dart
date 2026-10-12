import 'package:baby_family/data/provider/circle.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-10 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final leaveFamilyControllerProvider =
    ChangeNotifierProvider.autoDispose<LeaveFamilyController>(
      LeaveFamilyController.new,
    );

class LeaveFamilyController extends BaseNotifier {
  LeaveFamilyController(super.ref);

  ICircleService get circleService => ref.read(circleServiceProvider);
}
