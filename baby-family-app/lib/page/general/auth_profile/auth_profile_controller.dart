import 'package:baby_family/data/dto/onboarding_samples.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// AUTH-04 — hồ sơ cơ bản (tên điền sẵn, 2 đồng ý mặc định bật). Lưu xong:
/// chưa có lời mời → ONB-03; có lời mời chờ → áp dụng (ONB-ACT / CIR-01).
final authProfileControllerProvider =
    ChangeNotifierProvider.autoDispose<AuthProfileController>(
      AuthProfileController.new,
    );

class AuthProfileController extends BaseNotifier {
  AuthProfileController(super.ref) {
    loadSamples();
  }

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  /// Giá trị mẫu điền sẵn (tải sau khi mock store sẵn sàng).
  OnboardingSamples samples = const OnboardingSamples();
  bool samplesLoaded = false;

  Future<void> loadSamples() async {
    final value = await sessionService.samples();
    if (isDisposed) {
      return;
    }
    samples = value;
    samplesLoaded = true;
    notifyListeners();
  }

  /// Phiên sau thao tác — view điều hướng bằng `routeForSession`.
  AppSession get session => ref.read(sessionServiceProvider).current;

  String get initialName {
    final name = sessionService.userName;
    return name.isNotEmpty ? name : samples.profileName;
  }

  bool acceptTerms = true;
  bool acceptData = true;

  void toggleTerms() {
    acceptTerms = !acceptTerms;
    notifyListeners();
  }

  void toggleData() {
    acceptData = !acceptData;
    notifyListeners();
  }

  Future<void> save(String name) async {
    await whileLoading(() async {
      await sessionService.saveProfile(name: name);
    });
  }
}
