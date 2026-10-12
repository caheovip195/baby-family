import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SPL-01 — tải dữ liệu phiên (mock store) trước khi điều hướng.
final splashControllerProvider =
    ChangeNotifierProvider.autoDispose<SplashController>(SplashController.new);

class SplashController extends BaseNotifier {
  SplashController(super.ref);

  /// Thời gian hiển thị tối thiểu để không nháy màn.
  static const minimumDisplay = Duration(milliseconds: 900);

  Future<AppSession> restore() async {
    final delay = Future<void>.delayed(minimumDisplay);
    final session = await ref.read(sessionServiceProvider).restore();
    await delay;
    return session;
  }
}
