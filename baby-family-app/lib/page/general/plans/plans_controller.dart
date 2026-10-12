import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/plan_info.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SUB-01 — Chọn gói (paywall). Mua mock thành công ngay (SUB-02 là sheet
/// của Store); mặc định chọn Family như thiết kế.
final plansControllerProvider =
    ChangeNotifierProvider.autoDispose<PlansController>(PlansController.new);

class PlansController extends BaseNotifier {
  PlansController(super.ref) {
    load();
  }

  IFamilyService get familyService => ref.read(familyServiceProvider);

  List<PlanOffer> offers = const [];
  PlanInfo? plan;
  PlanState selected = PlanState.family;

  /// Phiên sau thao tác — view điều hướng bằng `routeForSession`.
  AppSession get session => ref.read(sessionServiceProvider).current;

  /// “Dùng thử còn N ngày” — null khi không còn dùng thử.
  int? get trialDaysLeft {
    final value = plan;
    final endsAt = value?.endsAt;
    if (value == null || value.state != PlanState.trial || endsAt == null) {
      return null;
    }
    return daysUntil(endsAt, ref.read(todayProvider));
  }

  PlanOffer? get selectedOffer =>
      offers.where((offer) => offer.code == selected).firstOrNull;

  bool get isCurrentPlan => plan?.state == selected;

  Future<void> load() async {
    final results = await Future.wait([
      familyService.planOffers(),
      familyService.currentFamily(),
    ]);
    if (isDisposed) {
      return;
    }
    offers = results[0]! as List<PlanOffer>;
    plan = (results[1] as Family?)?.plan;
    notifyListeners();
  }

  void select(PlanState value) {
    selected = value;
    notifyListeners();
  }

  Future<void> purchase() async {
    await whileLoading(() => familyService.purchasePlan(selected));
  }
}
