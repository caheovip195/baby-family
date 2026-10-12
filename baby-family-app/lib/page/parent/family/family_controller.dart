import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/legacy.dart';

/// FAM-01 — Tổng quan gia đình: gói, Papa & Mama, các con, người thân.
final familyControllerProvider =
    ChangeNotifierProvider.autoDispose<FamilyController>(FamilyController.new);

class FamilyController extends BaseNotifier {
  FamilyController(super.ref) {
    // Nạp sau microtask: không đổi trạng thái khi provider đang được dựng.
    ref.listen(mockRevisionProvider, (_, _) => Future.microtask(load));
    Future.microtask(load);
  }

  IFamilyService get familyService => ref.read(familyServiceProvider);

  Family? family;
  Member? me;

  /// Người đang dùng trước, bạn đời sau (Pencil “Papa (bạn)” rồi “Mama”).
  List<Member> parents = const [];
  List<Member> relatives = const [];
  List<Child> children = const [];
  List<PlanOffer> offers = const [];
  bool hasError = false;

  DateTime get today => ref.read(todayProvider);

  bool get allowsRelatives => family?.plan.state.allowsRelatives ?? false;

  /// Giá gói đang dùng, dạng gọn của Pencil (“599.000đ/năm”).
  String? get planPrice {
    final state = family?.plan.state;
    for (final offer in offers) {
      if (offer.code == state) {
        return offer.priceText.replaceAll(' / ', '/');
      }
    }
    return null;
  }

  /// Tên gọi của Papa / Mama (mô tả quan hệ “Mẹ của Papa”).
  String callNameOf(FamilyRole role) {
    for (final parent in parents) {
      if (parent.role == role) {
        return parent.callName;
      }
    }
    return role == FamilyRole.mother
        ? kValueDefaultCallNameMother
        : kValueDefaultCallNameFather;
  }

  /// Tên các bé người thân đang theo dõi (theo thứ tự các con, bỏ bé tạm ẩn).
  List<String> followedChildNames(Member relative) => [
    for (final child in children)
      if (relative.childPermissions[child.id] case final permission?
          when permission != RelativePermission.hidden)
        child.name,
  ];

  Future<void> load() async {
    hasError = false;
    toLoading();
    try {
      final results = await Future.wait([
        familyService.currentFamily(),
        familyService.members(),
        familyService.me(),
        ref.read(childServiceProvider).children(),
        familyService.planOffers(),
      ]);
      if (isDisposed) {
        return;
      }
      family = results[0] as Family?;
      final members = results[1]! as List<Member>;
      me = results[2] as Member?;
      parents = [
        ...members.where((m) => m.role.isParent && m.id == me?.id),
        ...members.where((m) => m.role.isParent && m.id != me?.id),
      ];
      relatives = members.where((m) => !m.role.isParent).toList();
      children = results[3]! as List<Child>;
      offers = results[4]! as List<PlanOffer>;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    toIdle();
  }
}
