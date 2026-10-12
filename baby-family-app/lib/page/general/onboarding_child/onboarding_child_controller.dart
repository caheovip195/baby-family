import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// ONB-05b — hồ sơ bé: các bé đã thêm (chip), form bé mới (điền sẵn bé mẫu),
/// “Thêm bé khác”, “Hoàn tất” → ONB-08.
final onboardingChildControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingChildController>(
      OnboardingChildController.new,
    );

class OnboardingChildController extends BaseNotifier {
  OnboardingChildController(super.ref) {
    load();
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  IChildService get childService => ref.read(childServiceProvider);

  DateTime get today => ref.read(todayProvider);

  /// Bé đã chào đời trong gia đình (chip “Hana · 2 tuổi 4 tháng”).
  List<Child> babies = const [];

  /// Tổng số hồ sơ (bé + thai kỳ) — chọn màu bé kế tiếp.
  int childCount = 0;

  String initialName = '';
  DateTime? birthDate;
  ChildGender gender = ChildGender.unknown;

  /// Tăng mỗi lần thêm bé để view làm mới ô tên.
  int formVersion = 0;

  Future<void> load() async {
    if (formVersion == 0 && initialName.isEmpty) {
      final samples = await sessionService.samples();
      if (isDisposed) {
        return;
      }
      initialName = samples.childName;
      birthDate ??= samples.birthDate;
      formVersion++;
    }
    final all = await childService.children();
    if (isDisposed) {
      return;
    }
    babies = all.where((child) => !child.isPregnancy).toList();
    childCount = all.length;
    notifyListeners();
  }

  void setBirthDate(DateTime value) {
    birthDate = value;
    notifyListeners();
  }

  void setGender(ChildGender value) {
    gender = value;
    notifyListeners();
  }

  Future<void> _save(String name) async {
    if (name.trim().isEmpty) {
      return;
    }
    await childService.addChild(
      name: name.trim(),
      birthDate: birthDate,
      gender: gender,
    );
  }

  /// “Thêm bé khác”: lưu bé đang nhập rồi mở form trống.
  Future<void> addAnother(String name) async {
    await whileLoading(() => _save(name));
    if (isDisposed) {
      return;
    }
    initialName = '';
    birthDate = null;
    gender = ChildGender.unknown;
    formVersion++;
    await load();
  }

  Future<void> complete(String name) async {
    await whileLoading(() => _save(name));
  }
}
