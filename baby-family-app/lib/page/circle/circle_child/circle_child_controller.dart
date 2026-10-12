import 'package:baby_family/data/provider/circle.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CIR-02 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final circleChildControllerProvider =
    ChangeNotifierProvider.autoDispose<CircleChildController>(
      CircleChildController.new,
    );

class CircleChildController extends BaseNotifier {
  CircleChildController(super.ref);

  ICircleService get circleService => ref.read(circleServiceProvider);
}
