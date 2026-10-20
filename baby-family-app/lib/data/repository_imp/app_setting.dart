import 'package:baby_family/data/model/settings/display_settings_record.dart';
import 'package:baby_family/data/repository/app_setting.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/local_store.dart';

class AppSettingRepositoryImp extends BaseRepositoryImp
    implements IAppSettingRepository {
  @override
  AppLanguage? savedLanguage() =>
      AppLanguage.fromCode(LocalStore().languageCode);

  @override
  Future<void> saveLanguage(AppLanguage language) =>
      LocalStore().saveLanguageCode(language.code);

  @override
  Future<void> syncLanguageToServer(AppLanguage language) async {
    await client!.updateMe({'locale': language.code});
  }

  @override
  JsonMap? savedDisplay() => LocalStore().displayPrefs;

  @override
  Future<void> saveDisplay(JsonMap prefs) =>
      LocalStore().saveDisplayPrefs(prefs);

  @override
  Future<DisplaySettingsRecord?> fetchServerDisplay() async =>
      (await client!.getMySettings()).settings;

  @override
  Future<void> syncDisplayToServer(JsonMap patch) async {
    await client!.updateMySettings(patch);
  }
}
