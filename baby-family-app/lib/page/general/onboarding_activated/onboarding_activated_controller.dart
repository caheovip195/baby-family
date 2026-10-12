import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// ONB-ACT — nhà mình đã đủ Papa & Mama: dùng thử 3 tháng tới `plan.endsAt`.
final onboardingActivatedControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingActivatedController>(
      OnboardingActivatedController.new,
    );

class OnboardingActivatedController extends BaseNotifier {
  OnboardingActivatedController(super.ref) {
    load();
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  Family? family;
  List<Member> parents = const [];
  List<PlanOffer> offers = const [];

  PlanOffer? offer(PlanState code) =>
      offers.where((item) => item.code == code).firstOrNull;

  Future<void> load() async {
    final service = ref.read(familyServiceProvider);
    final (currentFamily, members, planOffers) = await (
      service.currentFamily(),
      service.members(),
      service.planOffers(),
    ).wait;
    if (isDisposed) {
      return;
    }
    family = currentFamily;
    parents = members.where((member) => member.role.isParent).toList()
      ..sort(
        (a, b) => a.role == FamilyRole.father
            ? -1
            : b.role == FamilyRole.father
            ? 1
            : 0,
      );
    offers = planOffers;
    notifyListeners();
  }
}
