import 'dart:async';

import 'package:baby_family/data/dto/display_prefs.dart';
import 'package:baby_family/data/repository/app_setting.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository_imp/app_setting.dart';
import 'package:baby_family/data/service/app_setting.dart';
import 'package:baby_family/data/service_imp/base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:baby_family/utils/helper/local_store.dart';
import 'package:flutter/material.dart';
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
    unawaited(_syncLanguageToServer(language));
  }

  Future<void> _syncLanguageToServer(AppLanguage language) async {
    if (kValueDemoEnabled) {
      return;
    }
    try {
      if (await LocalStore().getAuthCertificate() == null) {
        return;
      }
      await _repository.syncLanguageToServer(language);
    } catch (e) {
      // Thử lại ở lần mở app sau (bootstrap gửi Accept-Language).
      Logger().w('Đồng bộ ngôn ngữ lên server thất bại: $e');
    }
  }

  // ------------------------------------------------------------ SET-06

  static const _themes = {
    ThemeMode.system: 'SYSTEM',
    ThemeMode.light: 'LIGHT',
    ThemeMode.dark: 'DARK',
  };

  @override
  DisplayPrefs currentDisplay() {
    final saved = _repository.savedDisplay() ?? const {};
    return DisplayPrefs(
      theme: ThemeMode.values.asNameMap()[saved['theme']] ?? ThemeMode.system,
      textScale: (saved['textScale'] as num?)?.toDouble() ?? 1,
      showLunar: saved['showLunar'] as bool? ?? true,
    );
  }

  @override
  Future<void> changeDisplay({
    ThemeMode? theme,
    double? textScale,
    bool? showLunar,
  }) async {
    final current = currentDisplay();
    await _save(
      DisplayPrefs(
        theme: theme ?? current.theme,
        textScale: textScale ?? current.textScale,
        showLunar: showLunar ?? current.showLunar,
      ),
    );
    unawaited(
      _syncDisplay({
        'theme': ?_themes[theme],
        'textScale': ?textScale,
        'showLunar': ?showLunar,
      }),
    );
  }

  @override
  Future<DisplayPrefs?> pullServerDisplay() async {
    if (kValueDemoEnabled || await LocalStore().getAuthCertificate() == null) {
      return null;
    }
    try {
      final record = await _repository.fetchServerDisplay();
      if (record == null) {
        return null;
      }
      final current = currentDisplay();
      final prefs = DisplayPrefs(
        theme:
            _themes.entries
                .where((entry) => entry.value == record.theme)
                .firstOrNull
                ?.key ??
            current.theme,
        // App hiển thị từ 1 (server cho phép 0.8).
        textScale: (record.textScale ?? current.textScale).clamp(1, 2),
        showLunar: record.showLunar ?? current.showLunar,
      );
      await _save(prefs);
      return prefs;
    } catch (e) {
      Logger().w('Không đọc được cài đặt hiển thị: $e');
      return null;
    }
  }

  Future<void> _save(DisplayPrefs prefs) => _repository.saveDisplay({
    'theme': prefs.theme.name,
    'textScale': prefs.textScale,
    'showLunar': prefs.showLunar,
  });

  Future<void> _syncDisplay(JsonMap patch) async {
    if (patch.isEmpty ||
        kValueDemoEnabled ||
        await LocalStore().getAuthCertificate() == null) {
      return;
    }
    try {
      await _repository.syncDisplayToServer(patch);
    } catch (e) {
      Logger().w('Đồng bộ cài đặt hiển thị thất bại: $e');
    }
  }
}
