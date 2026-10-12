import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// FAM-02 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final partnerInviteControllerProvider =
    ChangeNotifierProvider.autoDispose<PartnerInviteController>(
      PartnerInviteController.new,
    );

class PartnerInviteController extends BaseNotifier {
  PartnerInviteController(super.ref);

  IFamilyService get familyService => ref.read(familyServiceProvider);
}
