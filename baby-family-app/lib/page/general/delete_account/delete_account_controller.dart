import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/model/settings/delete_account_info.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-09 — Xoá tài khoản, 3 màn trong một trang: 1 Tác động (SET-09),
/// 2 Gia đình (SET-09b — còn bạn đời `mCafo` / Parent duy nhất `sA3Ch`),
/// 3–4 Xác thực & xác nhận (SET-09c). Luồng mock đi thẳng: “Xoá tài khoản”
/// luôn thành công, phiên về `fresh` → Welcome.
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

  void verify() {
    verified = true;
    notifyListeners();
  }

  void toggleAcknowledged() {
    acknowledged = !acknowledged;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await whileLoading(settingsService.deleteAccount);
  }
}
