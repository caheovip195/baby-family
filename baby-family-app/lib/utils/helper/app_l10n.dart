import 'dart:ui';

import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/local_store.dart';

/// Ngôn ngữ hiện hành của app: lựa chọn đã lưu → ngôn ngữ thiết bị (nếu hỗ
/// trợ) → [AppLanguage.fallback].
AppLanguage currentAppLanguage() {
  return AppLanguage.fromCode(LocalStore().languageCode) ?? deviceAppLanguage();
}

AppLanguage deviceAppLanguage() {
  for (final locale in PlatformDispatcher.instance.locales) {
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
