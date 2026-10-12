import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// ONB-04 — giai đoạn của nhà mình (mặc định “Đang mang thai” như thiết kế).
final onboardingStageControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingStageController>(
      OnboardingStageController.new,
    );

class OnboardingStageController extends BaseNotifier {
  OnboardingStageController(super.ref) {
    stage = sessionService.current.stage ?? FamilyStage.pregnant;
    load();
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  late FamilyStage stage;
  Member? me;
  Member? partner;

  Future<void> load() async {
    final service = ref.read(familyServiceProvider);
    final (mine, theirs) = await (service.me(), service.partner()).wait;
    if (isDisposed) {
      return;
    }
    me = mine;
    partner = theirs;
    notifyListeners();
  }

  void select(FamilyStage value) {
    stage = value;
    notifyListeners();
  }

  Future<void> submit() async {
    await whileLoading(() async {
      await sessionService.setStage(stage);
    });
  }
}
