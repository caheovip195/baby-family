// Design tokens are intentionally static namespaces.
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:baby_family/utils/constants/colors.dart';
import 'package:flutter/material.dart';

/// Typography — tài liệu nghiệp vụ mục 10.3.
/// Tiêu đề: Nunito (700/800). Nội dung: Be Vietnam Pro (400/500/600).
abstract final class AppTypography {
  static const headingFamily = 'Nunito';
  static const bodyFamily = 'BeVietnamPro';

  /// Hỗ trợ cỡ chữ hệ thống tới 200% (chế độ chữ lớn cho ông bà).
  static const maximumScale = 2.0;

  static const display = TextStyle(
    fontFamily: headingFamily,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w800,
    color: kColorTextPrimary2E2A27,
  );

  static const h1 = TextStyle(
    fontFamily: headingFamily,
    fontSize: 26,
    height: 34 / 26,
    fontWeight: FontWeight.w800,
    color: kColorTextPrimary2E2A27,
  );

  static const h2 = TextStyle(
    fontFamily: headingFamily,
    fontSize: 22,
    height: 30 / 22,
    fontWeight: FontWeight.w700,
    color: kColorTextPrimary2E2A27,
  );

  static const h3 = TextStyle(
    fontFamily: headingFamily,
    fontSize: 18,
    height: 26 / 18,
    fontWeight: FontWeight.w700,
    color: kColorTextPrimary2E2A27,
  );

  static const bodyLarge = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 17,
    height: 26 / 17,
    fontWeight: FontWeight.w400,
    color: kColorTextPrimary2E2A27,
  );

  static const body = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
    color: kColorTextPrimary2E2A27,
  );

  static const bodyStrong = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w600,
    color: kColorTextPrimary2E2A27,
  );

  static const label = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w600,
  );

  static const caption = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    color: kColorTextSecondary6B625B,
  );

  static const overline = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: kColorTextSecondary6B625B,
  );

  /// Giữ cỡ chữ người dùng chọn, chỉ chặn trên [maximumScale] để layout
  /// không vỡ.
  static TextScaler readableTextScaler(TextScaler platformScaler) {
    final platformScale = platformScaler.scale(14) / 14;
    if (platformScale <= maximumScale) {
      return platformScaler;
    }
    return const TextScaler.linear(maximumScale);
  }
}

/// Bo góc — tài liệu nghiệp vụ mục 10.5.
abstract final class AppRadius {
  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 14.0;

  /// Nút chính, thẻ nhiệm vụ.
  static const lg = 16.0;

  /// Thẻ nội dung (ký ức, thẻ Trang chủ).
  static const xl = 20.0;

  /// Dialog.
  static const dialog = 24.0;

  /// Bottom sheet (2 góc trên).
  static const sheet = 28.0;
  static const full = 999.0;
}

/// Khoảng cách hệ 4pt — tài liệu nghiệp vụ mục 10.4.
abstract final class AppSpacing {
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s8 = 32.0;
  static const s10 = 40.0;
  static const s12 = 48.0;

  /// Lề màn hình.
  static const screen = 20.0;

  /// Vùng chạm tối thiểu.
  static const minTouchTarget = 48.0;

  /// Chiều cao nút chính.
  static const buttonHeight = 52.0;
}

/// Bóng đổ — tài liệu nghiệp vụ mục 10.6.
abstract final class AppShadows {
  static const card = [
    BoxShadow(
      color: kColorShadow2E2A27Alpha06,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const floating = [
    BoxShadow(
      color: kColorShadow2E2A27Alpha10,
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
  ];
}

abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: kColorPrimary500EE7B67,
      primary: kColorPrimary600C2513F,
      onPrimary: kColorWhite,
      secondary: kColorSecondary5006FAE8E,
      error: kColorErrorD14B4B,
      surface: kColorSurfaceFFFFFF,
      onSurface: kColorTextPrimary2E2A27,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppTypography.bodyFamily,
      scaffoldBackgroundColor: kColorBgFFFBF7,
      dividerColor: kColorBorderEADFD6,
      appBarTheme: const AppBarTheme(
        backgroundColor: kColorBgFFFBF7,
        surfaceTintColor: kColorTransparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: kColorTextPrimary2E2A27,
        titleTextStyle: AppTypography.h3,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: kColorPrimary600C2513F,
          foregroundColor: kColorWhite,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          textStyle: AppTypography.label,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kColorPrimary600C2513F,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          textStyle: AppTypography.label,
          side: const BorderSide(color: kColorPrimary600C2513F, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kColorSurfaceVariantF7F1EC,
        hintStyle: AppTypography.body.copyWith(color: kColorTextTertiary9C928A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: kColorPrimary500EE7B67, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: kColorErrorD14B4B),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: kColorSurfaceFFFFFF,
        surfaceTintColor: kColorTransparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: kColorTextPrimary2E2A27,
        contentTextStyle: AppTypography.body.copyWith(color: kColorBgFFFBF7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
