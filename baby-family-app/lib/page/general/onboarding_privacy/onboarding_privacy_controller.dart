import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// ONB-08 — controller khung (foundation). Agent khu vực bổ sung state/logic.
final onboardingPrivacyControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingPrivacyController>(
      OnboardingPrivacyController.new,
    );

class OnboardingPrivacyController extends BaseNotifier {
  OnboardingPrivacyController(super.ref);

  ISessionService get sessionService => ref.read(sessionServiceProvider);
}
