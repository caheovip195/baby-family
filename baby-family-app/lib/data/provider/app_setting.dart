import 'package:baby_family/data/service/app_setting.dart';
import 'package:baby_family/data/service_imp/app_setting.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appSettingServiceProvider = Provider<IAppSettingService>(
  (ref) => AppSettingServiceImp(),
);

/// Ngôn ngữ đang hiển thị. `MaterialApp` watch provider này nên đổi ngôn ngữ
/// có hiệu lực ngay, không cần khởi động lại app.
final appLanguageProvider = NotifierProvider<AppLanguageNotifier, AppLanguage>(
  AppLanguageNotifier.new,
);

/// Display preferences applied by RootApp for the current mock session.
final appAppearanceProvider =
    NotifierProvider<AppAppearanceNotifier, ThemeMode>(
      AppAppearanceNotifier.new,
    );
final appTextScaleProvider = NotifierProvider<AppTextScaleNotifier, double>(
  AppTextScaleNotifier.new,
);

/// SET-06 “Hiện ngày âm lịch” (mặc định bật theo thiết kế).
final appLunarDateProvider = NotifierProvider<AppLunarNotifier, bool>(
  AppLunarNotifier.new,
);

/// SET-06 “Giảm hiệu ứng chuyển động” — RootApp bật `disableAnimations`.
final appReduceMotionProvider = NotifierProvider<AppToggleNotifier, bool>(
  AppToggleNotifier.new,
);

class AppToggleNotifier extends Notifier<bool> {
  AppToggleNotifier({this.initial = false});

  final bool initial;

  @override
  bool build() => initial;

  void change(bool value) => state = value;
}

/// Giá trị đầu đọc từ bản lưu trên máy; đổi → lưu + đồng bộ server (SET-06).
class AppAppearanceNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() =>
      ref.read(appSettingServiceProvider).currentDisplay().theme;

  void change(ThemeMode mode) {
    state = mode;
    ref.read(appSettingServiceProvider).changeDisplay(theme: mode);
  }

  /// Áp giá trị đã có (từ server) mà không đồng bộ ngược.
  void apply(ThemeMode mode) => state = mode;
}

class AppTextScaleNotifier extends Notifier<double> {
  @override
  double build() =>
      ref.read(appSettingServiceProvider).currentDisplay().textScale;

  void change(double scale) {
    state = scale.clamp(1, 2);
    ref.read(appSettingServiceProvider).changeDisplay(textScale: state);
  }

  void apply(double scale) => state = scale.clamp(1, 2);
}

class AppLunarNotifier extends Notifier<bool> {
  @override
  bool build() =>
      ref.read(appSettingServiceProvider).currentDisplay().showLunar;

  void change(bool value) {
    state = value;
    ref.read(appSettingServiceProvider).changeDisplay(showLunar: value);
  }

  void apply(bool value) => state = value;
}

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
