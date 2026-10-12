import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-13 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final safetySupportControllerProvider =
    ChangeNotifierProvider.autoDispose<SafetySupportController>(
      SafetySupportController.new,
    );

class SafetySupportController extends BaseNotifier {
  SafetySupportController(super.ref);

  IUsService get usService => ref.read(usServiceProvider);
}
