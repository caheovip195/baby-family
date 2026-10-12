import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// AUTH-01 — đăng nhập Apple/Google (mock luôn thành công) hoặc số điện thoại.
final authControllerProvider =
    ChangeNotifierProvider.autoDispose<AuthController>(AuthController.new);

class AuthController extends BaseNotifier {
  AuthController(super.ref);

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  /// Phiên sau thao tác — view điều hướng bằng `routeForSession`.
  AppSession get session => ref.read(sessionServiceProvider).current;

  AppLanguage get language => ref.read(appLanguageProvider);

  Future<void> changeLanguage(AppLanguage language) async {
    await ref.read(appLanguageProvider.notifier).change(language);
    if (!isDisposed) {
      notifyListeners();
    }
  }

  Future<void> signInApple() async {
    await whileLoading(() async {
      await sessionService.signIn(AuthMethod.apple);
    });
  }

  Future<void> signInGoogle() async {
    await whileLoading(() async {
      await sessionService.signIn(AuthMethod.google);
    });
  }
}
