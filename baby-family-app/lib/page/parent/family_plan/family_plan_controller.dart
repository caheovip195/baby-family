import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/family/plan_details.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/plan_text.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SUB-03 — Gói của gia đình (gói trả phí đang dùng): người thanh toán, kênh
/// mua, dung lượng theo loại, lượt AI, giới hạn video. “Đổi gói” → SUB-04
/// (đang House) hoặc SUB-01.
final familyPlanControllerProvider =
    ChangeNotifierProvider.autoDispose<FamilyPlanController>(
      FamilyPlanController.new,
    );

class FamilyPlanController extends BaseNotifier {
  FamilyPlanController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  IFamilyService get familyService => ref.read(familyServiceProvider);

  PlanDetails? details;
  Family? family;
  Member? me;
  List<Member> members = const [];
  List<PlanOffer> offers = const [];
  bool hasError = false;

  PlanState? get state => details?.plan.state;

  /// Giá gói đang dùng (“599.000đ/năm”).
  String? get price {
    final offer = offers.where((o) => o.code == state).firstOrNull;
    return offer == null ? null : compactPriceText(offer.priceText);
  }

  Member? get payer =>
      members.where((m) => m.userId == details?.payerUserId).firstOrNull;

  bool get isPayer =>
      me != null && details?.payerUserId != null && me!.userId == payer?.userId;

  /// Tên gọi của Bố/Mẹ còn lại (người không thanh toán) — ghi chú cuối màn.
  String get otherParentCallName =>
      members
          .where(
            (m) => m.role != FamilyRole.relative && m.userId != payer?.userId,
          )
          .firstOrNull
          ?.callName ??
      '';

  Future<void> load() async {
    hasError = false;
    try {
      final results = await Future.wait<Object?>([
        familyService.planDetails(),
        familyService.currentFamily(),
        familyService.me(),
        familyService.members(),
        familyService.planOffers(),
      ]);
      if (isDisposed) {
        return;
      }
      details = results[0] as PlanDetails?;
      family = results[1] as Family?;
      me = results[2] as Member?;
      members = results[3]! as List<Member>;
      offers = results[4]! as List<PlanOffer>;
    } on Object {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }
}
