import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/phone_format.dart';
import 'package:hooks_riverpod/legacy.dart';

/// Bước đổi số: xác thực lại bằng số hiện tại → nhập số mới → mã gửi tới số
/// mới → xong (các thiết bị khác bị đăng xuất).
enum ChangePhoneStep { reauth, newPhone, verify, done }

final changePhoneControllerProvider =
    ChangeNotifierProvider.autoDispose<ChangePhoneController>(
      ChangePhoneController.new,
    );

class ChangePhoneController extends BaseNotifier {
  ChangePhoneController(super.ref);

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  static const otpLength = 6;

  ChangePhoneStep step = ChangePhoneStep.reauth;
  bool reauthSent = false;
  String code = '';
  String phoneInput = '';

  /// Số mới dạng E.164 (+84…).
  String get newPhone =>
      '$kValueDefaultDialCode${normalizeLocalPhone(phoneInput)}';

  bool get canSubmitCode => code.length == otpLength && !isLoading;

  bool get canSendNewPhone =>
      normalizeLocalPhone(phoneInput).length >= 9 && !isLoading;

  void setCode(String value) {
    code = value.trim();
    notifyListeners();
  }

  void setPhone(String value) {
    phoneInput = value;
    notifyListeners();
  }

  Future<void> sendReauth() async {
    await whileLoading(settingsService.requestReauthOtp);
    reauthSent = true;
    code = '';
    notifyListeners();
  }

  Future<void> verifyReauth() async {
    await whileLoading(() => settingsService.verifyReauth(code));
    step = ChangePhoneStep.newPhone;
    code = '';
    notifyListeners();
  }

  Future<void> sendNewPhoneCode() async {
    await whileLoading(() => settingsService.requestPhoneChange(newPhone));
    step = ChangePhoneStep.verify;
    code = '';
    notifyListeners();
  }

  Future<void> confirm() async {
    await whileLoading(
      () => settingsService.confirmPhoneChange(newPhone, code),
    );
    step = ChangePhoneStep.done;
    notifyListeners();
  }
}
