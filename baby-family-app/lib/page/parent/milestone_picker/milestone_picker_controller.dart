import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/milestone_group.dart';
import 'package:baby_family/data/model/memory/milestone_option.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-11 Chọn cột mốc: tìm kiếm, nhóm dạng tab ngang, mục đã ghi có ✓ (mờ),
/// “Cột mốc riêng của nhà mình”. Chọn → trả cột mốc về MEM-05.
final milestonePickerControllerProvider = ChangeNotifierProvider.autoDispose
    .family<MilestonePickerController, String?>(MilestonePickerController.new);

class MilestonePickerController extends BaseNotifier {
  MilestonePickerController(super.ref, String? childId) {
    _childId = childId ?? ref.read(selectedSubjectProvider);
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);

  String? _childId;
  bool loaded = false;
  bool hasError = false;
  List<Child> children = const [];
  List<MilestoneGroup> groups = const [];
  List<MilestoneOption> options = const [];
  String? groupCode;
  String query = '';

  DateTime get today => childService.today;

  Child? get child =>
      children.where((item) => item.id == _childId).firstOrNull ??
      children.firstOrNull;

  MilestoneGroup? get group =>
      groups.where((item) => item.code == groupCode).firstOrNull;

  /// Mục hiển thị: theo nhóm đang chọn, hoặc mọi nhóm khi đang tìm.
  List<MilestoneOption> get visibleOptions {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      return options.where((item) => item.group == groupCode).toList();
    }
    return options
        .where((item) => item.title.toLowerCase().contains(needle))
        .toList();
  }

  int get groupRecorded =>
      options.where((item) => item.group == groupCode && item.recorded).length;

  int get groupTotal => options.where((item) => item.group == groupCode).length;

  Future<void> load() async {
    hasError = false;
    try {
      final (kids, rows) = await (
        childService.children(),
        memoryService.milestoneGroups(),
      ).wait;
      if (isDisposed) {
        return;
      }
      children = kids.where((item) => !item.isPregnancy).toList();
      groups = rows;
      groupCode ??= groups.firstOrNull?.code;
      final current = child;
      options = current == null
          ? const []
          : await memoryService.milestoneOptions(current.id);
      if (isDisposed) {
        return;
      }
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void selectGroup(String code) {
    groupCode = code;
    notifyListeners();
  }

  void search(String value) {
    query = value;
    notifyListeners();
  }

  Future<void> selectChild(String? id) async {
    if (id == null || id == _childId) {
      return;
    }
    _childId = id;
    await load();
  }

  /// Cột mốc riêng (tự đặt tên) — trả về như một lựa chọn.
  MilestoneOption custom(String title) => MilestoneOption(
    code: 'custom',
    group: groupCode ?? '',
    title: title.trim(),
  );
}
