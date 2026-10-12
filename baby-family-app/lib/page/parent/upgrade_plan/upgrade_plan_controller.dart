import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SUB-04 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final upgradePlanControllerProvider =
    ChangeNotifierProvider.autoDispose<UpgradePlanController>(
      UpgradePlanController.new,
    );

class UpgradePlanController extends BaseNotifier {
  UpgradePlanController(super.ref);

  IFamilyService get familyService => ref.read(familyServiceProvider);
}
