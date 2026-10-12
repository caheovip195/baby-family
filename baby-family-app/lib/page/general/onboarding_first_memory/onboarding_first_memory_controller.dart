import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// ONB-09 — ký ức đầu tiên (không có trong Pencil, tài liệu 9.2): “Chọn ảnh”
/// → kết thúc thiết lập + MEM composer; “Để sau” → Trang chủ.
final onboardingFirstMemoryControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingFirstMemoryController>(
      OnboardingFirstMemoryController.new,
    );

class OnboardingFirstMemoryController extends BaseNotifier {
  OnboardingFirstMemoryController(super.ref) {
    load();
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  /// Phiên sau thao tác — view điều hướng bằng `routeForSession`.
  AppSession get session => ref.read(sessionServiceProvider).current;

  /// Bé đầu tiên (ưu tiên bé đã chào đời) để gắn ký ức.
  Child? child;

  Future<void> load() async {
    final children = await ref.read(childServiceProvider).children();
    if (isDisposed) {
      return;
    }
    child =
        children.where((item) => !item.isPregnancy).lastOrNull ??
        children.firstOrNull;
    notifyListeners();
  }

  Future<void> finish() async {
    await whileLoading(() async {
      await sessionService.completeSetup();
    });
  }
}
