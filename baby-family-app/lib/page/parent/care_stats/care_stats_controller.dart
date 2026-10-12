import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-11 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final careStatsControllerProvider =
    ChangeNotifierProvider.autoDispose<CareStatsController>(
      CareStatsController.new,
    );

class CareStatsController extends BaseNotifier {
  CareStatsController(super.ref);

  ICareService get careService => ref.read(careServiceProvider);
}
