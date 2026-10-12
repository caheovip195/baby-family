import 'package:baby_family/data/dto/mission_draft.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-03 “Thêm nhiệm vụ” (mục 7.13.3): Việc gì → Cho ai → Ai làm (Tôi /
/// Cùng nhau — BR-020) → Khi nào & lặp → Nhắc → Gợi ý lưu ảnh → Lưu.
/// Form điền sẵn theo bản nháp mẫu; nút Lưu luôn đi tiếp (UI-first).
final missionCreateControllerProvider =
    ChangeNotifierProvider.autoDispose<MissionCreateController>(
      MissionCreateController.new,
    );

class MissionCreateController extends BaseNotifier {
  MissionCreateController(super.ref) {
    today = ref.read(todayProvider);
  }

  ICareService get careService => ref.read(careServiceProvider);

  late DateTime today;
  bool loaded = false;
  List<Child> children = const [];
  Member? partner;

  String title = '';
  String? templateId;
  String? icon;
  MissionScope scope = MissionScope.oneChild;
  List<String> childIds = const [];
  MissionOwnerKind ownerKind = MissionOwnerKind.me;
  bool tomorrow = false;
  String? dueTime;
  MissionRepeat repeat = MissionRepeat.none;
  List<int> repeatDays = const [];
  MissionReminder reminder = MissionReminder.none;
  bool memoryPrompt = true;

  /// Bé thật (không gồm thai kỳ) để chọn “Một bé / Nhiều bé”.
  List<Child> get babies =>
      children.where((child) => !child.isPregnancy).toList();

  String get partnerCallName => partner?.callName ?? '';

  bool get showsChildren =>
      scope == MissionScope.oneChild || scope == MissionScope.manyChildren;

  Future<void> init({String? childId, String? templateId}) async {
    final draft = await careService.missionDraft(
      childId: childId,
      templateId: templateId,
    );
    final loadedChildren = await ref.read(childServiceProvider).children();
    final loadedPartner = await ref.read(familyServiceProvider).partner();
    if (isDisposed) {
      return;
    }
    children = loadedChildren;
    partner = loadedPartner;
    _apply(draft);
    loaded = true;
    notifyListeners();
  }

  void _apply(MissionDraft draft, {bool keepSchedule = false}) {
    title = draft.title;
    templateId = draft.templateId;
    icon = draft.icon;
    if (draft.childIds.isNotEmpty || !keepSchedule) {
      childIds = draft.childIds;
      scope = switch (draft.childIds.length) {
        0 => keepSchedule ? scope : MissionScope.family,
        1 => MissionScope.oneChild,
        _ => MissionScope.manyChildren,
      };
    }
    if (keepSchedule) {
      return;
    }
    ownerKind = draft.ownerKind;
    dueTime = draft.dueTime;
    repeat = draft.repeat;
    repeatDays = draft.repeatDays;
    reminder = draft.reminder;
    memoryPrompt = draft.memoryPrompt;
  }

  /// CARE-04 trả về mẫu đã chọn.
  Future<void> applyTemplate(String id) async {
    final draft = await careService.missionDraft(
      childId: childIds.length == 1 ? childIds.first : null,
      templateId: id,
    );
    if (isDisposed) {
      return;
    }
    _apply(draft, keepSchedule: true);
    notifyListeners();
  }

  void setTitle(String value) {
    title = value;
    // Sửa tên → thành nhiệm vụ tự gõ (CUSTOM, BR-069).
    templateId = null;
  }

  void setScope(MissionScope value) {
    scope = value;
    if (value == MissionScope.couple) {
      ownerKind = MissionOwnerKind.together;
    }
    if (!showsChildren) {
      childIds = const [];
    } else if (value == MissionScope.oneChild && childIds.length > 1) {
      childIds = [childIds.first];
    } else if (childIds.isEmpty && babies.isNotEmpty) {
      childIds = [babies.first.id];
    }
    notifyListeners();
  }

  void toggleChild(String id) {
    if (scope == MissionScope.oneChild) {
      childIds = [id];
    } else {
      final next = [...childIds];
      next.contains(id) ? next.remove(id) : next.add(id);
      childIds = next;
    }
    notifyListeners();
  }

  void setOwner(MissionOwnerKind value) {
    if (scope == MissionScope.couple) {
      return;
    }
    ownerKind = value;
    notifyListeners();
  }

  void toggleDay() {
    tomorrow = !tomorrow;
    notifyListeners();
  }

  void setDueTime(String? value) {
    dueTime = value;
    notifyListeners();
  }

  void nextRepeat() {
    const order = MissionRepeat.values;
    repeat = order[(order.indexOf(repeat) + 1) % order.length];
    if (repeat == MissionRepeat.customDays && repeatDays.isEmpty) {
      repeatDays = [today.weekday];
    }
    notifyListeners();
  }

  void nextReminder() {
    const order = MissionReminder.values;
    reminder = order[(order.indexOf(reminder) + 1) % order.length];
    notifyListeners();
  }

  void setMemoryPrompt(bool value) {
    memoryPrompt = value;
    notifyListeners();
  }

  /// Lưu (không chặn — UI-first): tên trống thì giữ tên mẫu/bản nháp.
  Future<bool> save() async {
    final result = await callFuture(
      careService.createMission(
        title: title,
        templateId: templateId,
        ownerKind: ownerKind,
        childIds: childIds,
        date: today.add(Duration(days: tomorrow ? 1 : 0)),
        dueTime: dueTime,
        repeat: repeat,
        reminder: reminder,
        icon: icon,
      ),
    );
    return result.isSuccess;
  }
}
