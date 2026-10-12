import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/on_this_day_group.dart';
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

/// MEM-16 Ngày này năm xưa: ký ức cùng ngày các năm trước theo từng năm
/// (“1 năm trước”, “2 năm trước”) + “Chia sẻ lại với chú thích mới”.
final onThisDayControllerProvider =
    ChangeNotifierProvider.autoDispose<OnThisDayController>(
      OnThisDayController.new,
    );

class OnThisDayController extends BaseNotifier {
  OnThisDayController(super.ref) {
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
  List<OnThisDayGroup> groups = const [];
  List<Child> children = const [];
  List<Member> members = const [];

  DateTime get today => childService.today;

  int get memoryCount =>
      groups.fold(0, (sum, group) => sum + group.memories.length);

  Child? childById(String? id) =>
      children.where((child) => child.id == id).firstOrNull;

  Member? memberByUser(String? userId) =>
      members.where((member) => member.userId == userId).firstOrNull;

  Future<void> load() async {
    hasError = false;
    try {
      final (rows, kids, people) = await (
        memoryService.onThisDay(),
        childService.children(),
        familyService.members(),
      ).wait;
      if (isDisposed) {
        return;
      }
      groups = rows;
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
