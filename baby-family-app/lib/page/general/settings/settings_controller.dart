import 'package:baby_family/data/dto/account_settings_summary.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-01 — Cài đặt: hồ sơ, các nhóm cài đặt, đăng xuất.
final settingsControllerProvider =
    ChangeNotifierProvider.autoDispose<SettingsController>(
      SettingsController.new,
    );

class SettingsController extends BaseNotifier {
  SettingsController(super.ref) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => notifyListeners());
    load();
    _loadVersion();
  }

  IFamilyService get familyService => ref.read(familyServiceProvider);

  Member? me;
  Family? family;
  AccountSettingsSummary summary = const AccountSettingsSummary();
  String? appVersion;
  bool hasError = false;

  AppLanguage get language => ref.read(appLanguageProvider);

  /// Phiên sau thao tác — view điều hướng bằng `routeForSession`.
  AppSession get session => ref.read(sessionServiceProvider).current;

  Future<void> load() async {
    hasError = false;
    try {
      final results = await Future.wait([
        familyService.me(),
        familyService.currentFamily(),
        familyService.settingsSummary(),
      ]);
      if (isDisposed) {
        return;
      }
      me = results[0] as Member?;
      family = results[1] as Family?;
      summary = results[2]! as AccountSettingsSummary;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  Future<void> _loadVersion() async {
    final version = await familyService.appVersion();
    if (isDisposed) {
      return;
    }
    appVersion = version;
    notifyListeners();
  }

  Future<void> signOut() async {
    await whileLoading(() async {
      await ref.read(sessionServiceProvider).signOut();
    });
  }
}
