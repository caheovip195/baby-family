import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/us/couple_settings.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// US-15 “Cài đặt Papa & Mama” (mục 9.8, Pencil `kVZ2v`) — cài đặt của riêng
/// tôi: mặc định chia sẻ mood, ẩn trên màn hình khoá, khoá Face ID, lời nhờ
/// “Sớm nhé” vượt giờ yên tĩnh, thời gian giữ phiên Cầu nối, xoá lịch sử mood.
/// Mỗi thay đổi lưu ngay.
final coupleSettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<CoupleSettingsController>(
      CoupleSettingsController.new,
    );

class CoupleSettingsController extends BaseNotifier {
  CoupleSettingsController(super.ref) {
    load();
  }

  IUsService get usService => ref.read(usServiceProvider);

  /// Lựa chọn giữ nội dung Cầu nối (ngày; 0 = xoá ngay).
  static const retentionOptions = [0, 7, 30, 90];

  bool loaded = false;
  bool hasError = false;
  CoupleSettings settings = const CoupleSettings();
  Member? partner;

  String get partnerCallName => partner?.callName ?? '';

  Future<void> load() async {
    hasError = false;
    try {
      final loadedSettings = await usService.coupleSettings();
      final loadedPartner = await ref.read(familyServiceProvider).partner();
      if (isDisposed) {
        return;
      }
      settings = loadedSettings;
      partner = loadedPartner;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  Future<void> _save(CoupleSettings value) async {
    settings = value;
    notifyListeners();
    await usService.saveCoupleSettings(value);
  }

  Future<void> setShareMode(CheckinShareMode mode) =>
      _save(settings.copyWith(checkinShareMode: mode));

  Future<void> setHideOnLockScreen(bool value) =>
      _save(settings.copyWith(hideOnLockScreen: value));

  Future<void> setFaceIdLock(bool value) =>
      _save(settings.copyWith(faceIdLock: value));

  Future<void> setUrgentBypass(bool value) =>
      _save(settings.copyWith(urgentBypassQuiet: value));

  Future<void> setRetention(int days) =>
      _save(settings.copyWith(bridgeRetentionDays: days));
}
