import 'package:baby_family/data/repository/app_setting.dart';
import 'package:baby_family/data/repository_imp/app_setting.dart';
import 'package:baby_family/data/service/app_setting.dart';
import 'package:baby_family/data/service_imp/base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:baby_family/utils/helper/local_store.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class AppSettingServiceImp extends BaseServiceImp
    implements IAppSettingService {
  final IAppSettingRepository _repository = AppSettingRepositoryImp();

  @override
  AppLanguage currentLanguage() =>
      _repository.savedLanguage() ?? deviceAppLanguage();

  @override
  Future<void> changeLanguage(AppLanguage language) async {
    await _repository.saveLanguage(language);
    Intl.defaultLocale = language.code;
    if (await LocalStore().getAuthCertificate() == null) {
      return;
    }
    try {
      await _repository.syncLanguageToServer(language);
    } catch (e) {
      // Thử lại ở lần mở app sau (bootstrap gửi Accept-Language).
      Logger().w('Đồng bộ ngôn ngữ lên server thất bại: $e');
    }
  }
}
