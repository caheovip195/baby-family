import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/model/settings/security_settings.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-07 — Bảo mật & Thiết bị: khoá Face ID, mã PIN, thiết bị đăng nhập.
final securitySettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<SecuritySettingsController>(
      SecuritySettingsController.new,
    );

class SecuritySettingsController extends BaseNotifier {
  SecuritySettingsController(super.ref) {
    load();
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  SecuritySettings? settings;
  bool hasError = false;

  DateTime get now => ref.read(appClockProvider).now();

  /// Phiên sau “Đăng xuất mọi thiết bị” — view điều hướng bằng
  /// `routeForSession`.
  AppSession get session => ref.read(sessionServiceProvider).current;

  Future<void> load() async {
    hasError = false;
    try {
      final result = await settingsService.securitySettings();
      if (isDisposed) {
        return;
      }
      settings = result;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  Future<void> setFaceIdLock(bool value) async {
    final current = settings;
    if (current == null) {
      return;
    }
    settings = current.copyWith(faceIdLock: value);
    notifyListeners();
    await settingsService.saveSecuritySettings(settings!);
  }

  Future<void> signOutDevice(String deviceId) async {
    await settingsService.signOutDevice(deviceId);
    await load();
  }

  /// Đăng xuất mọi thiết bị, kể cả máy này (mock: về Welcome).
  Future<void> signOutAll() async {
    await whileLoading(() async {
      await settingsService.signOutOtherDevices();
      await ref.read(sessionServiceProvider).signOut();
    });
  }
}
