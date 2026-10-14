import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/month_recap.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// REC-03 — Tháng tuổi (Pencil `OtCDE`, mục 9.10): trang 1 của bản tổng kết
/// tháng cho một bé — ảnh tháng trước / tháng này, số liệu, lần đầu, câu nói
/// & giọng nói, chia sẻ với người thân / lưu / tải ảnh.
final monthRecapControllerProvider = ChangeNotifierProvider.autoDispose
    .family<MonthRecapController, String?>(MonthRecapController.new);

class MonthRecapController extends BaseNotifier {
  MonthRecapController(super.ref, this.childId) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  /// Bé được chọn (null = bé có bản tổng kết gần nhất).
  final String? childId;

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  bool loaded = false;
  bool hasError = false;
  MonthRecap? recap;
  Child? child;
  List<Member> members = const [];

  DateTime get today => childService.today;

  Member? memberByUser(String? userId) =>
      members.where((member) => member.userId == userId).firstOrNull;

  Future<void> load() async {
    hasError = false;
    try {
      final (value, kids, people) = await (
        memoryService.monthRecap(childId: childId),
        childService.children(),
        familyService.members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      recap = value;
      child = kids.where((kid) => kid.id == value?.childId).firstOrNull;
      members = people;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }
}
