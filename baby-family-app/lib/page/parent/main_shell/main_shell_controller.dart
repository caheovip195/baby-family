import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/shell.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// Main shell — điều phối tab và QC-01.
final mainShellControllerProvider =
    ChangeNotifierProvider.autoDispose<MainShellController>(
      MainShellController.new,
    );

class MainShellController extends BaseNotifier {
  MainShellController(super.ref);

  /// Chủ thể đang chọn (SW-01) — dùng làm bé mặc định cho QC-01.
  String? get subjectId => ref.read(selectedSubjectProvider);

  /// Ghi nhận hành động cho tab Papa & Mama (check-in mở sheet US-02).
  void requestCoupleAction(QuickCreateAction action) =>
      ref.read(pendingQuickActionProvider.notifier).request(action);
}
