import 'package:baby_family/data/dto/family_deletion_info.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// Xoá gia đình (mục 7.25): một Bố/Mẹ yêu cầu (xác thực lại bằng OTP), người
/// còn lại đồng ý (cũng xác thực lại) → hẹn xoá sau [FamilyDeletionInfo.graceDays]
/// ngày; trong thời gian đó ai trong hai người cũng huỷ được.
final familyDeletionControllerProvider =
    ChangeNotifierProvider.autoDispose<FamilyDeletionController>(
      FamilyDeletionController.new,
    );

class FamilyDeletionController extends BaseNotifier {
  FamilyDeletionController(super.ref) {
    Future.microtask(load);
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  static const otpLength = 6;

  FamilyDeletionInfo? info;
  bool hasError = false;
  bool otpSent = false;
  String otpCode = '';

  bool get canVerify => otpCode.length == otpLength && !isLoading;

  /// Bước cần xác thực lại: yêu cầu xoá, hoặc đồng ý khi người kia yêu cầu.
  bool get needsMyApproval =>
      info?.status == FamilyDeletionStatus.awaitingPartner &&
      info?.requestedByMe == false;

  Future<void> load() async {
    hasError = false;
    try {
      final loaded = await settingsService.familyDeletion();
      if (isDisposed) {
        return;
      }
      info = loaded;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

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

  /// Xác thực lại rồi yêu cầu / đồng ý xoá; lỗi ném ra để view báo.
  Future<void> verifyAndSubmit() async {
    await whileLoading(() async {
      await settingsService.verifyReauth(otpCode);
      info = needsMyApproval
          ? await settingsService.confirmFamilyDeletion()
          : await settingsService.requestFamilyDeletion();
    });
    otpSent = false;
    otpCode = '';
    notifyListeners();
  }

  Future<void> cancel() async {
    await whileLoading(() async {
      info = await settingsService.cancelFamilyDeletion();
    });
    notifyListeners();
  }
}
