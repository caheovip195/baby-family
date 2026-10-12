import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:hooks_riverpod/legacy.dart';

/// ONB-05a — thai kỳ: tên ở nhà, ngày dự sinh (hoặc tuần thai), số bé.
/// Điền sẵn bé mẫu theo thiết kế (Bơ, 24/01/2027).
final onboardingPregnancyControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingPregnancyController>(
      OnboardingPregnancyController.new,
    );

class OnboardingPregnancyController extends BaseNotifier {
  OnboardingPregnancyController(super.ref) {
    load();
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  DateTime get today => ref.read(todayProvider);

  String initialName = '';
  bool loaded = false;

  Future<void> load() async {
    final samples = await sessionService.samples();
    if (isDisposed) {
      return;
    }
    initialName = samples.pregnancyName;
    dueDate ??= samples.dueDate;
    loaded = true;
    notifyListeners();
  }

  DateTime? dueDate;

  /// “Mình chỉ biết tuần thai” — nhập tuần thay cho ngày dự sinh.
  bool weekMode = false;
  int babyCount = 1;

  /// Sau ONB-05a còn ONB-05b khi “Đã có bé và đang mang thai”.
  bool get alsoHasChild => sessionService.current.stage == FamilyStage.both;

  int get week => dueDate == null
      ? kValuePregnancyMinWeek
      : pregnancyWeek(dueDate!, today).week;

  void toggleWeekMode() {
    weekMode = !weekMode;
    notifyListeners();
  }

  void setDueDate(DateTime value) {
    dueDate = value;
    notifyListeners();
  }

  void setWeek(int value) {
    dueDate = dueDateFromWeek(value, today);
    notifyListeners();
  }

  void setBabyCount(int value) {
    babyCount = value;
    notifyListeners();
  }

  Future<void> submit(String name) async {
    await whileLoading(() async {
      await ref
          .read(childServiceProvider)
          .addPregnancy(
            name: name.trim().isEmpty ? initialName : name.trim(),
            dueDate: dueDate,
            babyCount: babyCount,
          );
    });
  }
}
