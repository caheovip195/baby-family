import 'package:baby_family/data/model/settings/display_settings_record.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

abstract class IAppSettingRepository extends IBaseRepository {
  /// Ngôn ngữ đã lưu trên máy (null = chưa chọn).
  AppLanguage? savedLanguage();

  Future<void> saveLanguage(AppLanguage language);

  /// Đồng bộ ngôn ngữ lên server (`PATCH /v1/me {locale}`) để push, email,
  /// nội dung catalog trả đúng ngôn ngữ.
  Future<void> syncLanguageToServer(AppLanguage language);

  /// SET-06 hiển thị đã lưu trên máy (`{theme, textScale, showLunar}`).
  JsonMap? savedDisplay();

  Future<void> saveDisplay(JsonMap prefs);

  /// `GET /v1/me/settings` — hiển thị đặt trên máy khác.
  Future<DisplaySettingsRecord?> fetchServerDisplay();

  /// `PATCH /v1/me/settings` (chỉ trường đổi).
  Future<void> syncDisplayToServer(JsonMap patch);
}
