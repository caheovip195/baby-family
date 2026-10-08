import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

abstract class IAppSettingService extends IBaseService {
  /// Ngôn ngữ hiện hành: đã chọn → ngôn ngữ thiết bị → mặc định (vi).
  AppLanguage currentLanguage();

  /// Đổi ngôn ngữ: lưu trên máy ngay, đồng bộ server nếu đang đăng nhập
  /// (lỗi mạng không chặn việc đổi ngôn ngữ).
  Future<void> changeLanguage(AppLanguage language);
}
