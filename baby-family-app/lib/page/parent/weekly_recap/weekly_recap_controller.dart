import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/weekly_recap.dart';
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

/// REC-02 Tuần của nhà mình: ảnh ghép, số khoảnh khắc • lần đầu • câu nói,
/// điểm nhấn, “Cả nhà cùng nhau”, chia sẻ với người thân / lưu / tải ảnh.
final weeklyRecapControllerProvider =
    ChangeNotifierProvider.autoDispose<WeeklyRecapController>(
      WeeklyRecapController.new,
    );

class WeeklyRecapController extends BaseNotifier {
  WeeklyRecapController(super.ref) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);

  bool loaded = false;
  bool hasError = false;
  WeeklyRecap? recap;
  List<Child> children = const [];
  List<Member> members = const [];

  DateTime get today => childService.today;

  Child? childById(String? id) =>
      children.where((child) => child.id == id).firstOrNull;

  Member? memberByUser(String? userId) =>
      members.where((member) => member.userId == userId).firstOrNull;

  Future<void> load() async {
    hasError = false;
    try {
      final (value, kids, people) = await (
        memoryService.weeklyRecap(),
        childService.children(),
        familyService.members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      recap = value;
      children = kids;
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
