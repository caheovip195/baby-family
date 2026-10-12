import 'package:baby_family/data/dto/couple_today.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/shell.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-01 — Papa & Mama: “Hôm nay của hai ta”, lời nhờ đang mở, câu hỏi hôm
/// nay, lời cảm ơn gần đây, lối vào (mục 9.8). Mở US-02 (check-in) từ thẻ của
/// tôi hoặc từ QC-01 (`pendingQuickActionProvider`).
final coupleTabControllerProvider =
    ChangeNotifierProvider.autoDispose<CoupleTabController>(
      CoupleTabController.new,
    );

class CoupleTabController extends BaseNotifier {
  CoupleTabController(super.ref) {
    ref.listen(mockRevisionProvider, (_, _) => load());
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);

  CoupleToday? today;
  Member? me;
  Member? partner;
  List<Child> children = const [];
  bool hasError = false;
  int _revision = 0;

  /// Giờ hiện tại của dữ liệu (thời gian tương đối “hôm qua”, “2 phút trước”).
  DateTime get now => ref.read(appClockProvider).now();

  String? get myUserId => me?.userId;

  Child? childById(String id) =>
      children.where((child) => child.id == id).firstOrNull;

  Future<void> load() async {
    final revision = ++_revision;
    final firstLoad = today == null;
    if (firstLoad) {
      toLoading();
    }
    try {
      final family = ref.read(familyServiceProvider);
      final results = await Future.wait<Object?>([
        usService.coupleToday(),
        family.me(),
        family.partner(),
        ref.read(childServiceProvider).children(),
      ]);
      if (isDisposed || revision != _revision) {
        return;
      }
      today = results[0]! as CoupleToday;
      me = results[1] as Member?;
      partner = results[2] as Member?;
      children = results[3]! as List<Child>;
      hasError = false;
    } catch (_) {
      if (isDisposed || revision != _revision) {
        return;
      }
      hasError = true;
    }
    if (firstLoad) {
      toIdle();
    }
    notifyListeners();
  }

  /// QC-01 “Check-in”: lấy hành động đang chờ (nếu là check-in) rồi xoá.
  bool consumeCheckinRequest() {
    final pending = ref.read(pendingQuickActionProvider);
    if (pending != QuickCreateAction.checkin) {
      return false;
    }
    ref.read(pendingQuickActionProvider.notifier).consume();
    return true;
  }

  /// US-02 → lưu check-in; US-01 tự cập nhật qua `mockRevisionProvider`.
  Future<bool> saveCheckin({
    required MoodCode mood,
    required int energy,
    required List<CoupleNeed> needs,
    required bool shared,
  }) async {
    try {
      await usService.checkIn(
        mood: mood,
        energy: energy,
        needs: needs,
        shared: shared,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> answerQuestion(String answer) async {
    if (answer.trim().isEmpty) {
      return;
    }
    await usService.answerQuestion(answer);
  }
}
