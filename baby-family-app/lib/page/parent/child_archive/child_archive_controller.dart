import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CHD-05 — controller khung (foundation batch 3). Agent khu vực bổ sung
/// state/logic theo Pencil.
final childArchiveControllerProvider =
    ChangeNotifierProvider.autoDispose<ChildArchiveController>(
      ChildArchiveController.new,
    );

class ChildArchiveController extends BaseNotifier {
  ChildArchiveController(super.ref);

  IChildService get childService => ref.read(childServiceProvider);
}
