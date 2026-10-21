import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/family/plan_details.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/repository/store_purchase.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SUB-04 — Nâng cấp House → Family: bảng so sánh từ catalog gói, giá hiện
/// tại → giá Family, xác nhận SUB-02 rồi mua (mock thành công ngay).
final upgradePlanControllerProvider =
    ChangeNotifierProvider.autoDispose<UpgradePlanController>(
      UpgradePlanController.new,
    );

class UpgradePlanController extends BaseNotifier {
  UpgradePlanController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  IFamilyService get familyService => ref.read(familyServiceProvider);

  List<PlanOffer> offers = const [];
  PlanDetails? details;
  Family? family;
  List<Member> members = const [];
  bool hasError = false;

  PlanOffer? offerOf(PlanState code) =>
      offers.where((offer) => offer.code == code).firstOrNull;

  PlanOffer? get house => offerOf(PlanState.house);

  PlanOffer? get familyOffer => offerOf(PlanState.family);

  Member? get payer =>
      members.where((m) => m.userId == details?.payerUserId).firstOrNull;

  String get payerCallName => payer?.callName ?? '';

  /// Bố/Mẹ không thanh toán (“Papa sẽ thấy…”).
  String get otherParentCallName =>
      members
          .where(
            (m) => m.role != FamilyRole.relative && m.userId != payer?.userId,
          )
          .firstOrNull
          ?.callName ??
      '';

  String callNameOf(FamilyRole role) =>
      members.where((m) => m.role == role).firstOrNull?.callName ??
      (role == FamilyRole.father
          ? kValueDefaultCallNameFather
          : kValueDefaultCallNameMother);

  bool get inTrial => family?.plan.state == PlanState.trial;

  Future<void> load() async {
    hasError = false;
    try {
      final results = await Future.wait<Object?>([
        familyService.planOffers(),
        familyService.planDetails(),
        familyService.currentFamily(),
        familyService.members(),
      ]);
      if (isDisposed) {
        return;
      }
      offers = results[0]! as List<PlanOffer>;
      details = results[1] as PlanDetails?;
      family = results[2] as Family?;
      members = results[3]! as List<Member>;
    } on Object {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  /// `false` khi người dùng huỷ ở bảng thanh toán của Store.
  Future<bool> upgrade() async {
    try {
      await whileLoading(() => familyService.purchasePlan(PlanState.family));
    } on StorePurchaseCancelled {
      return false;
    }
    return true;
  }
}
