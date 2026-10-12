import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-09 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final bridgeRewriteControllerProvider =
    ChangeNotifierProvider.autoDispose<BridgeRewriteController>(
      BridgeRewriteController.new,
    );

class BridgeRewriteController extends BaseNotifier {
  BridgeRewriteController(super.ref);

  IUsService get usService => ref.read(usServiceProvider);
}
