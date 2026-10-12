import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-05 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final aiSettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<AiSettingsController>(
      AiSettingsController.new,
    );

class AiSettingsController extends BaseNotifier {
  AiSettingsController(super.ref);

  ISettingsService get settingsService => ref.read(settingsServiceProvider);
}
