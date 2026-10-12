import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-10 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final bridgeInviteControllerProvider =
    ChangeNotifierProvider.autoDispose<BridgeInviteController>(
      BridgeInviteController.new,
    );

class BridgeInviteController extends BaseNotifier {
  BridgeInviteController(super.ref);

  IUsService get usService => ref.read(usServiceProvider);
}
