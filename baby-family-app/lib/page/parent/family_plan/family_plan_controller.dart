import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SUB-03 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final familyPlanControllerProvider =
    ChangeNotifierProvider.autoDispose<FamilyPlanController>(
      FamilyPlanController.new,
    );

class FamilyPlanController extends BaseNotifier {
  FamilyPlanController(super.ref);

  IFamilyService get familyService => ref.read(familyServiceProvider);
}
