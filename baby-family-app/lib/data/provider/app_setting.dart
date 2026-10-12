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
final appLunarDateProvider = NotifierProvider<AppToggleNotifier, bool>(
  () => AppToggleNotifier(initial: true),
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

class AppAppearanceNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void change(ThemeMode mode) => state = mode;
}

class AppTextScaleNotifier extends Notifier<double> {
  @override
  double build() => 1;

  void change(double scale) => state = scale.clamp(1, 2);
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
