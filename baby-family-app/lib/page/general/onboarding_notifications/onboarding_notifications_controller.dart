import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/push.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// ONB-10 — xin quyền thông báo (pre-permission) với 3 thông báo mẫu.
final onboardingNotificationsControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingNotificationsController>(
      OnboardingNotificationsController.new,
    );

class OnboardingNotificationsController extends BaseNotifier {
  OnboardingNotificationsController(super.ref) {
    load();
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  Member? me;
  Member? partner;
  List<Child> babies = const [];

  Future<void> load() async {
    final family = ref.read(familyServiceProvider);
    final (mine, theirs, children) = await (
      family.me(),
      family.partner(),
      ref.read(childServiceProvider).children(),
    ).wait;
    if (isDisposed) {
      return;
    }
    me = mine;
    partner = theirs;
    babies = children.where((child) => !child.isPregnancy).toList();
    notifyListeners();
  }

  /// Hộp thoại hệ thống rồi (bản thật) đăng ký push token với server; lỗi
  /// nền tảng (giả lập/test) được bỏ qua trong service.
  Future<void> enable() async {
    await whileLoading(ref.read(pushServiceProvider).enable);
  }
}
