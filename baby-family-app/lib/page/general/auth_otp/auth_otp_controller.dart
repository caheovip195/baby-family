import 'package:baby_family/data/dto/onboarding_samples.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/phone_format.dart';
import 'package:hooks_riverpod/legacy.dart';

/// AUTH-03 — nhập OTP (mock: mọi mã đều hợp lệ), đếm ngược gửi lại mã.
final authOtpControllerProvider =
    ChangeNotifierProvider.autoDispose<AuthOtpController>(
      AuthOtpController.new,
    );

class AuthOtpController extends BaseNotifier {
  AuthOtpController(super.ref) {
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

  /// Các số đã gõ sẵn theo thiết kế (“482”).
  String get initialCode => samples.otpPrefill;

  /// “+84 912 345 678” cho dòng phụ.
  String get displayPhone {
    final phone =
        sessionService.current.phone ??
        '$kValueDefaultDialCode${samples.phone}';
    if (!phone.startsWith(kValueDefaultDialCode)) {
      return phone;
    }
    final local = phone.substring(kValueDefaultDialCode.length);
    return '$kValueDefaultDialCode ${formatLocalPhone(local)}';
  }

  Future<void> resend() async {
    final phone = sessionService.current.phone;
    if (phone != null) {
      await sessionService.requestOtp(phone);
    }
  }

  Future<void> verify(String code) async {
    await whileLoading(() async {
      await sessionService.verifyOtp(code);
    });
  }
}
