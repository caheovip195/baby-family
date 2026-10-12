import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SUB-07 — Hết dùng thử / gói hết hạn (bắt buộc, không đóng được). Thống kê
/// ấm áp từ ký ức của các bé đã sinh; dữ liệu giữ ~12 tháng (BR-058).
final expiredControllerProvider =
    ChangeNotifierProvider.autoDispose<ExpiredController>(
      ExpiredController.new,
    );

class ExpiredController extends BaseNotifier {
  ExpiredController(super.ref) {
    load();
  }

  IFamilyService get familyService => ref.read(familyServiceProvider);

  int memoryCount = 0;
  int firstsCount = 0;
  List<String> childNames = const [];

  /// Ngày dữ liệu bị xoá nếu không gia hạn (hết hạn + 12 tháng).
  DateTime? retainedUntil;

  /// Phiên sau thao tác — view điều hướng bằng `routeForSession`.
  AppSession get session => ref.read(sessionServiceProvider).current;

  Future<void> load() async {
    final childService = ref.read(childServiceProvider);
    final family = await familyService.currentFamily();
    final children = (await childService.children())
        .where((child) => !child.isPregnancy)
        .toList();
    final stats = await Future.wait(
      children.map((child) => childService.stats(child.id)),
    );
    if (isDisposed) {
      return;
    }
    memoryCount = stats.fold(0, (sum, item) => sum + item.memories);
    firstsCount = stats.fold(0, (sum, item) => sum + item.firsts);
    childNames = [for (final child in children) child.name];
    final endsAt = family?.plan.endsAt;
    retainedUntil = endsAt == null
        ? null
        : DateTime(
            endsAt.year,
            endsAt.month + kValueDataRetentionMonths,
            endsAt.day,
          );
    notifyListeners();
  }

  Future<void> signOut() async {
    await whileLoading(() => ref.read(sessionServiceProvider).signOut());
  }
}
