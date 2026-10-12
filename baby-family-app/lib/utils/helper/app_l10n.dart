import 'dart:ui';

import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/local_store.dart';

/// Ngôn ngữ hiện hành của app: lựa chọn đã lưu → ngôn ngữ thiết bị (nếu hỗ
/// trợ) → [AppLanguage.fallback].
AppLanguage currentAppLanguage() {
  return AppLanguage.fromCode(LocalStore().languageCode) ?? deviceAppLanguage();
}

AppLanguage deviceAppLanguage() =>
    appLanguageForLocales(PlatformDispatcher.instance.locales);

/// Chọn ngôn ngữ được hỗ trợ đầu tiên trong danh sách ưu tiên của thiết bị.
/// Nếu không có ngôn ngữ phù hợp, dùng tiếng Việt (BR-061).
AppLanguage appLanguageForLocales(Iterable<Locale> locales) {
  for (final locale in locales) {
    final language = AppLanguage.fromCode(locale.languageCode);
    if (language != null) {
      return language;
    }
  }
  return AppLanguage.fallback;
}

/// Chuỗi dịch dùng ở nơi KHÔNG có `BuildContext` (interceptor, helper,
/// service tạo nội dung thông báo cục bộ). Trong widget dùng `context.l10n`.
AppLocalizations currentL10n() {
  return lookupAppLocalizations(currentAppLanguage().locale);
}
