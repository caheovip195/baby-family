import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/model/settings/delete_account_info.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-09 — Xoá tài khoản, 3 màn trong một trang: 1 Tác động (SET-09),
/// 2 Gia đình (SET-09b — còn bạn đời `mCafo` / Parent duy nhất `sA3Ch`),
/// 3–4 Xác thực & xác nhận (SET-09c). Bản thật: xác thực lại bằng OTP tới số
/// của chính tôi rồi gửi yêu cầu xoá (chờ 30 ngày) và đăng xuất. Luồng mock đi
/// thẳng: “Xoá tài khoản” luôn thành công, phiên về `fresh` → Welcome.
final deleteAccountControllerProvider =
    ChangeNotifierProvider.autoDispose<DeleteAccountController>(
      DeleteAccountController.new,
    );

class DeleteAccountController extends BaseNotifier {
  DeleteAccountController(super.ref) {
    load();
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  /// Số bước hiển thị trên thanh tiến trình.
  static const stepCount = 4;

  /// Màn đang hiển thị: 1, 2 hoặc 3 (= bước 3–4).
  static const lastScreen = 3;

  DeleteAccountInfo? info;
  bool hasError = false;
  int screen = 1;

  /// SET-09: giữ ký ức đã đăng cho gia đình (mặc định) hay xoá.
  bool keepMemories = true;

  /// SET-09b (Parent duy nhất): true = mời Parent khác trước (mặc định).
  bool inviteParentFirst = true;

  /// SET-09c: đã đăng nhập lại / đã tích xác nhận.
  bool verified = false;
  bool acknowledged = false;

  /// Đã gửi OTP xác thực lại — hiện ô nhập mã.
  bool otpSent = false;
  String otpCode = '';

  /// Độ dài mã OTP (AUTH-03).
  static const otpLength = 6;

  bool get canVerifyOtp => otpCode.length == otpLength && !isLoading;

  /// “Xoá tài khoản” chỉ bật khi đã xác thực lại và đã tích xác nhận.
  bool get canDelete => verified && acknowledged && !isLoading;

  AppSession get session => ref.read(sessionServiceProvider).current;

  Future<void> load() async {
    hasError = false;
    try {
      final result = await settingsService.deleteAccountInfo();
      if (isDisposed) {
        return;
      }
      info = result;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  void next() {
    if (screen < lastScreen) {
      screen++;
      notifyListeners();
    }
  }

  /// Lùi một bước; false khi đang ở bước đầu (view tự đóng trang).
  bool back() {
    if (screen <= 1) {
      return false;
    }
    screen--;
    notifyListeners();
    return true;
  }

  void setKeepMemories(bool value) {
    keepMemories = value;
    notifyListeners();
  }

  void setInviteParentFirst(bool value) {
    inviteParentFirst = value;
    notifyListeners();
  }

  /// Đăng nhập lại bằng Apple (bản mock).
  void verify() {
    verified = true;
    notifyListeners();
  }

  /// “Dùng mã OTP qua SĐT …” → gửi mã; lỗi ném ra để view báo snack bar.
  Future<void> sendOtp() async {
    await whileLoading(settingsService.requestReauthOtp);
    otpSent = true;
    otpCode = '';
    notifyListeners();
  }

  void setOtpCode(String value) {
    otpCode = value.trim();
    notifyListeners();
  }

  /// Xác nhận mã; sai mã ném lỗi (`OTP_INVALID`) để view báo snack bar.
  Future<void> verifyOtp() async {
    await whileLoading(() => settingsService.verifyReauth(otpCode));
    verified = true;
    otpSent = false;
    notifyListeners();
  }

  void toggleAcknowledged() {
    acknowledged = !acknowledged;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await whileLoading(
      () => settingsService.deleteAccount(keepMemories: keepMemories),
    );
  }
}
