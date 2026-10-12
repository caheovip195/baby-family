import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-06 — Hiển thị & Ngôn ngữ: ngôn ngữ, giao diện, cỡ chữ, âm lịch, giảm
/// chuyển động. Mọi lựa chọn đổi ngay qua provider của RootApp (7.27, AC-081).
final displaySettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<DisplaySettingsController>(
      DisplaySettingsController.new,
    );

class DisplaySettingsController extends BaseNotifier {
  DisplaySettingsController(super.ref) {
    ref
      ..listen(appLanguageProvider, (_, _) => notifyListeners())
      ..listen(appAppearanceProvider, (_, _) => notifyListeners())
      ..listen(appTextScaleProvider, (_, _) => notifyListeners())
      ..listen(appLunarDateProvider, (_, _) => notifyListeners())
      ..listen(appReduceMotionProvider, (_, _) => notifyListeners());
    load();
  }

  /// Tên bé trong câu xem trước cỡ chữ (bé sinh gần nhất).
  String? previewName;

  AppLanguage get language => ref.read(appLanguageProvider);
  ThemeMode get themeMode => ref.read(appAppearanceProvider);
  AppTextSize get textSize =>
      AppTextSize.fromScale(ref.read(appTextScaleProvider));
  bool get lunarDate => ref.read(appLunarDateProvider);
  bool get reduceMotion => ref.read(appReduceMotionProvider);

  Future<void> load() async {
    final children = await ref.read(childServiceProvider).children();
    if (isDisposed) {
      return;
    }
    final babies = children.where((child) => child.birthDate != null).toList()
      ..sort((a, b) => b.birthDate!.compareTo(a.birthDate!));
    previewName = babies.firstOrNull?.name;
    notifyListeners();
  }

  Future<void> changeLanguage(AppLanguage value) =>
      ref.read(appLanguageProvider.notifier).change(value);

  void changeTheme(ThemeMode value) =>
      ref.read(appAppearanceProvider.notifier).change(value);

  void changeTextSize(AppTextSize value) =>
      ref.read(appTextScaleProvider.notifier).change(value.scale);

  void changeLunarDate(bool value) =>
      ref.read(appLunarDateProvider.notifier).change(value);

  void changeReduceMotion(bool value) =>
      ref.read(appReduceMotionProvider.notifier).change(value);
}
