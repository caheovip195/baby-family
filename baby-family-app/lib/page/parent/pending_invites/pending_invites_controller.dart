import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// FAM-05 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final pendingInvitesControllerProvider =
    ChangeNotifierProvider.autoDispose<PendingInvitesController>(
      PendingInvitesController.new,
    );

class PendingInvitesController extends BaseNotifier {
  PendingInvitesController(super.ref);

  IFamilyService get familyService => ref.read(familyServiceProvider);
}
