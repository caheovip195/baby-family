import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/provider/circle.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CIR-05 — Gia đình tạm dừng chia sẻ (gia đình hạ gói House, gói hết hạn
/// hoặc bố mẹ tạm dừng người thân): không nêu lý do gói; Đóng / Rời gia đình.
final circlePausedControllerProvider =
    ChangeNotifierProvider.autoDispose<CirclePausedController>(
      CirclePausedController.new,
    );

class CirclePausedController extends BaseNotifier {
  CirclePausedController(super.ref) {
    Future.microtask(load);
  }

  ICircleService get circleService => ref.read(circleServiceProvider);

  CircleView? view;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final loaded = await circleService.view();
      if (isDisposed) {
        return;
      }
      view = loaded;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }
}
