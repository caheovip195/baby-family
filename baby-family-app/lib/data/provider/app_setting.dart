import 'package:baby_family/data/service/app_setting.dart';
import 'package:baby_family/data/service_imp/app_setting.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appSettingServiceProvider = Provider<IAppSettingService>(
  (ref) => AppSettingServiceImp(),
);

/// Ngôn ngữ đang hiển thị. `MaterialApp` watch provider này nên đổi ngôn ngữ
/// có hiệu lực ngay, không cần khởi động lại app.
final appLanguageProvider = NotifierProvider<AppLanguageNotifier, AppLanguage>(
  AppLanguageNotifier.new,
);

class AppLanguageNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() => ref.read(appSettingServiceProvider).currentLanguage();

  Future<void> change(AppLanguage language) async {
    if (language == state) {
      return;
    }
    await ref.read(appSettingServiceProvider).changeLanguage(language);
    state = language;
  }
}
