import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/weekly_recap.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
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

  /// Người thân mở recap Bố Mẹ đã chia sẻ (BF-20261030-005): chỉ xem.
  bool get readOnly => ref.read(sessionServiceProvider).current.state.isCircle;

  Child? childById(String? id) =>
      children.where((child) => child.id == id).firstOrNull;

  Member? memberByUser(String? userId) =>
      members.where((member) => member.userId == userId).firstOrNull;

  Future<void> load() async {
    hasError = false;
    try {
      // Tên bé / tên gọi chỉ để chú thích: người thân không đọc được danh
      // sách đầy đủ thì vẫn hiện recap.
      Future<List<T>> optional<T>(Future<List<T>> Function() read) async {
        try {
          return await read();
        } catch (_) {
          return const [];
        }
      }

      final (value, kids, people) = await (
        memoryService.weeklyRecap(),
        optional(childService.children),
        optional(familyService.members),
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

  /// REC-02 chia sẻ / dừng chia sẻ với người thân (gói Family); trả trạng
  /// thái mới.
  Future<bool> toggleShare() async {
    final current = recap;
    if (current == null) {
      return false;
    }
    final next = await whileLoading(
      () => memoryService.shareWeeklyRecap(current, shared: !current.shared),
    );
    if (!isDisposed) {
      recap = next;
      notifyListeners();
    }
    return next.shared;
  }

  /// REC-02 lưu vào timeline (một ký ức mỗi tuần) → id ký ức.
  Future<String?> saveToTimeline() async {
    final current = recap;
    if (current == null) {
      return null;
    }
    final memoryId = await whileLoading(
      () => memoryService.saveWeeklyRecapToTimeline(current),
    );
    if (!isDisposed && memoryId != null) {
      recap = current.copyWith(memoryId: memoryId);
      notifyListeners();
    }
    return memoryId;
  }
}
