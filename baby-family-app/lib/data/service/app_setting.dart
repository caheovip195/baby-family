import 'package:baby_family/data/dto/display_prefs.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter/material.dart';

abstract class IAppSettingService extends IBaseService {
  /// Ngôn ngữ hiện hành: đã chọn → ngôn ngữ thiết bị → mặc định (vi).
  AppLanguage currentLanguage();

  /// Đổi ngôn ngữ: lưu trên máy ngay, đồng bộ server nếu đang đăng nhập
  /// (lỗi mạng không chặn việc đổi ngôn ngữ).
  Future<void> changeLanguage(AppLanguage language);

  /// SET-06: hiển thị đã lưu trên máy (mặc định khi chưa đặt).
  DisplayPrefs currentDisplay();

  /// Lưu trên máy ngay; đồng bộ server (`PATCH /me/settings`) khi đã đăng
  /// nhập — lỗi mạng không chặn việc đổi.
  Future<void> changeDisplay({
    ThemeMode? theme,
    double? textScale,
    bool? showLunar,
  });

  /// Lúc mở app: hiển thị đặt trên máy khác (server) → lưu trên máy và trả
  /// về để áp dụng; null khi không có/lỗi.
  Future<DisplayPrefs?> pullServerDisplay();
}
