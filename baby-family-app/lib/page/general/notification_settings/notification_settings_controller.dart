import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/settings/notification_settings.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-03 — Thông báo: bật/tắt từng nhóm, giờ yên tĩnh, màn hình khoá,
/// bản tin người thân. Mỗi thay đổi lưu ngay (mock).
final notificationSettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<NotificationSettingsController>(
      NotificationSettingsController.new,
    );

class NotificationSettingsController extends BaseNotifier {
  NotificationSettingsController(super.ref) {
    load();
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  NotificationSettings? settings;

  /// Tên gọi của bạn đời (“Lời nhờ của Papa vượt giờ yên tĩnh”).
  String? partnerCallName;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final results = await Future.wait([
        settingsService.notificationSettings(),
        ref.read(familyServiceProvider).partner(),
      ]);
      if (isDisposed) {
        return;
      }
      settings = results[0]! as NotificationSettings;
      partnerCallName = (results[1] as Member?)?.callName;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  Future<void> toggleChannel(String code, bool enabled) => _update(
    (s) => s.copyWith(
      channels: [
        for (final channel in s.channels)
          channel.code == code ? channel.copyWith(enabled: enabled) : channel,
      ],
    ),
  );

  Future<void> setQuietHours(bool value) =>
      _update((s) => s.copyWith(quietHours: value));

  Future<void> setUrgentBypass(bool value) =>
      _update((s) => s.copyWith(urgentBypassQuiet: value));

  Future<void> setHideOnLockScreen(bool value) =>
      _update((s) => s.copyWith(hideOnLockScreen: value));

  Future<void> _update(
    NotificationSettings Function(NotificationSettings) change,
  ) async {
    final current = settings;
    if (current == null) {
      return;
    }
    settings = change(current);
    notifyListeners();
    await settingsService.saveNotificationSettings(settings!);
  }
}
