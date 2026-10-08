import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

abstract class IAppSettingRepository extends IBaseRepository {
  /// Ngôn ngữ đã lưu trên máy (null = chưa chọn).
  AppLanguage? savedLanguage();

  Future<void> saveLanguage(AppLanguage language);

  /// Đồng bộ ngôn ngữ lên server (`PATCH /v1/me {locale}`) để push, email,
  /// nội dung catalog trả đúng ngôn ngữ.
  Future<void> syncLanguageToServer(AppLanguage language);
}
