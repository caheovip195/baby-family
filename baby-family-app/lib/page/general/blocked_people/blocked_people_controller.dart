import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-13 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final blockedPeopleControllerProvider =
    ChangeNotifierProvider.autoDispose<BlockedPeopleController>(
      BlockedPeopleController.new,
    );

class BlockedPeopleController extends BaseNotifier {
  BlockedPeopleController(super.ref);

  ISettingsService get settingsService => ref.read(settingsServiceProvider);
}
