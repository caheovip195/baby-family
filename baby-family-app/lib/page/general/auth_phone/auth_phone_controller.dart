import 'package:baby_family/data/dto/onboarding_samples.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/phone_format.dart';
import 'package:hooks_riverpod/legacy.dart';

/// AUTH-02 — nhập số điện thoại (điền sẵn số mẫu), “Gửi mã” luôn đi tiếp.
final authPhoneControllerProvider =
    ChangeNotifierProvider.autoDispose<AuthPhoneController>(
      AuthPhoneController.new,
    );

class AuthPhoneController extends BaseNotifier {
  AuthPhoneController(super.ref) {
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

  /// Số mẫu đã định dạng nhóm 3 (“912 345 678”).
  String get initialPhone {
    final session = sessionService.current.phone;
    final raw = (session != null && session.startsWith(kValueDefaultDialCode))
        ? session.substring(kValueDefaultDialCode.length)
        : samples.phone;
    return formatLocalPhone(raw);
  }

  Future<void> sendCode(String phone) async {
    await whileLoading(() async {
      await sessionService.requestOtp(
        '$kValueDefaultDialCode${normalizeLocalPhone(phone)}',
      );
    });
  }
}
