import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-08 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final bridgeStartControllerProvider =
    ChangeNotifierProvider.autoDispose<BridgeStartController>(
      BridgeStartController.new,
    );

class BridgeStartController extends BaseNotifier {
  BridgeStartController(super.ref);

  IUsService get usService => ref.read(usServiceProvider);
}
