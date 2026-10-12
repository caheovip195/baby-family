import 'package:baby_family/data/model/care/family_tree.dart';
import 'package:baby_family/data/model/care/hearts_summary.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-09 “Cây gia đình” (mục 7.14): cây, cấp, % tới cấp sau (không số tổng
/// của gia đình), số liệu tuần, Hearts của CHÍNH tôi (BR-018).
final familyTreeControllerProvider =
    ChangeNotifierProvider.autoDispose<FamilyTreeController>(
      FamilyTreeController.new,
    );

class FamilyTreeController extends BaseNotifier {
  FamilyTreeController(super.ref) {
    today = ref.read(todayProvider);
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  ICareService get careService => ref.read(careServiceProvider);

  /// Số dòng lịch sử Hearts hiển thị (Pencil `DYLhu`).
  static const recentCount = 3;

  late DateTime today;
  FamilyTree? tree;
  HeartsSummary? hearts;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final loadedTree = await careService.tree();
      final loadedHearts = await careService.myHearts();
      if (isDisposed) {
        return;
      }
      tree = loadedTree;
      hearts = loadedHearts;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }
}
