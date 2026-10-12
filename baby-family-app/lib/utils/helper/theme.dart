// Design tokens are intentionally static namespaces.
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:baby_family/utils/constants/colors.dart';
import 'package:flutter/material.dart';

/// Typography — tài liệu nghiệp vụ mục 10.3.
/// Tiêu đề: Nunito (700/800). Nội dung: Be Vietnam Pro (400/500/600).
abstract final class AppTypography {
  static const headingFamily = 'Nunito';
  static const bodyFamily = 'BeVietnamPro';

  /// Chữ viết tay (Dancing Script) — chỉ cho giấy viết thư / phong bì MEM-14.
  static const handwritingFamily = 'DancingScript';

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

  // Compact type used by the original Pencil cards and tab bars (section 10.3).
  static const text14 = TextStyle(
    letterSpacing: 0,
    fontFamily: bodyFamily,
    fontSize: 14,
    height: 18 / 14,
    color: kColorTextPrimary2E2A27,
  );
  static const small = TextStyle(
    letterSpacing: 0,
    fontFamily: bodyFamily,
    fontSize: 12,
    height: 15 / 12,
    color: kColorTextSecondary6B625B,
  );
  static const tiny = TextStyle(
    letterSpacing: 0,
    fontFamily: bodyFamily,
    fontSize: 11,
    height: 14 / 11,
    color: kColorTextTertiary9C928A,
  );
  static const micro = TextStyle(
    letterSpacing: 0,
    fontFamily: bodyFamily,
    fontSize: 10,
    height: 13 / 10,
    color: kColorTextSecondary6B625B,
  );
  static const title17 = TextStyle(
    letterSpacing: 0,
    fontFamily: headingFamily,
    fontSize: 17,
    height: 23 / 17,
    fontWeight: FontWeight.w800,
    color: kColorTextPrimary2E2A27,
  );
  static const title16 = TextStyle(
    letterSpacing: 0,
    fontFamily: headingFamily,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w700,
    color: kColorTextPrimary2E2A27,
  );
  static const title20 = TextStyle(
    letterSpacing: 0,
    fontFamily: headingFamily,
    fontSize: 20,
    height: 27 / 20,
    fontWeight: FontWeight.w800,
    color: kColorTextPrimary2E2A27,
  );

  /// Chữ viết tay lớn (MEM-14 lời mở đầu, tên ký, tên trên phong bì): 24/700.
  static const handwriting = TextStyle(
    letterSpacing: 0,
    fontFamily: handwritingFamily,
    fontSize: 24,
    height: 29 / 24,
    fontWeight: FontWeight.w700,
    color: kColorPrimary700A2402F,
  );

  /// Chữ viết tay nhỏ (MEM-14 “Yêu con,”): 20/400.
  static const handwritingSmall = TextStyle(
    letterSpacing: 0,
    fontFamily: handwritingFamily,
    fontSize: 20,
    height: 24 / 20,
    fontWeight: FontWeight.w400,
    color: kColorTextPrimary2E2A27,
  );

  /// Keeps semantic text colors in sync with the current light/dark mode.
  /// Explicit black/white text belongs to photo viewers or button foregrounds.
  static TextStyle adapt(BuildContext context, TextStyle style) {
    final color = style.color;
    if (color == null ||
        color == kColorWhite ||
        color == kColorBlack ||
        color == kColorTransparent) {
      return style;
    }
    return style.copyWith(color: AppColors.resolve(context, color));
  }

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

/// Resolves documented light tokens to their dark equivalents without tinting media.
/// Pass semantic surface tokens here; explicit white/black artwork stays unchanged.
abstract final class AppColors {
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color resolve(BuildContext context, Color color) =>
      isDark(context) ? darkToken(color) : color;

  static Color onPrimary(BuildContext context) =>
      isDark(context) ? kColorDarkPrimary502A1A16 : kColorWhite;

  static Color darkToken(Color color) => switch (color) {
    kColorPrimary50FFF4F1 => kColorDarkPrimary502A1A16,
    kColorPrimary100FFE3DC => kColorDarkPrimary1003D231D,
    kColorPrimary300F7A796 => kColorDarkPrimary300C9705F,
    kColorPrimary500EE7B67 => kColorDarkPrimary500F4917F,
    kColorPrimary600C2513F => kColorDarkPrimary600F7A796,
    kColorPrimary700A2402F => kColorDarkPrimary700FFC2B5,
    kColorSecondary100E4F2EA => kColorDarkSecondary1001C2B23,
    kColorSecondary5006FAE8E => kColorDarkSecondary50086C3A3,
    kColorSecondary7003F7A5C => kColorDarkSecondary700A9D9BF,
    kColorAccent100FDF1D6 => kColorDarkAccent10033291A,
    kColorAccent500F4BF5C => kColorDarkAccent500F7CD7C,
    kColorAccent7009A6A12 => kColorDarkAccent500F7CD7C,
    kColorAccent600B7862B => kColorDarkAccent500F7CD7C,
    kColorAccentBorderF0DDB0 => kColorDarkBorder3A3430,
    kColorUs50F6F2FC => kColorDarkUs501F1A2B,
    kColorUs100EAE2F8 => kColorDarkUs1002C2440,
    kColorUs5009B85D1 => kColorDarkUs500B5A3E3,
    kColorUs7006A549F => kColorDarkUs700D2C6F0,
    kColorBgFFFBF7 => kColorDarkBg171412,
    kColorSurfaceFFFFFF => kColorDarkSurface221E1B,
    kColorSurfaceVariantF7F1EC => kColorDarkSurfaceVariant2C2724,
    kColorBorderEADFD6 => kColorDarkBorder3A3430,
    kColorTextPrimary2E2A27 => kColorDarkTextPrimaryF5EFEA,
    kColorTextSecondary6B625B => kColorDarkTextSecondaryBDB3AB,
    kColorTextTertiary9C928A => kColorDarkTextTertiary8A817A,
    kColorOverlay2E2A27Alpha48 => kColorDarkOverlayBlackAlpha60,
    kColorSheetScrim2E2A27Alpha60 => kColorDarkOverlayBlackAlpha60,
    kColorOverlay2E2A27Alpha50 => kColorDarkOverlayBlackAlpha60,
    kColorSuccess3E9B6E => kColorDarkSuccess6FCB9C,
    kColorWarningD98E1F => kColorDarkWarningF2B85B,
    kColorErrorD14B4B => kColorDarkErrorF08080,
    kColorInfo3F82BF => kColorDarkInfo7DB3E0,
    _ => color,
  };
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

  /// Thanh tab dưới (2 góc trên, Pencil luKhc).
  static const tabBar = 24.0;

  /// Ô ảnh nhỏ, ô ngày, ô thống kê (Pencil: 10–14).
  static const tile = 12.0;
  static const full = 999.0;
}

/// Khoảng cách hệ 4pt — tài liệu nghiệp vụ mục 10.4.
abstract final class AppSpacing {
  /// Intermediate measurements present in the Pencil components.
  static const compact = 6.0;
  static const itemGap = 10.0;
  static const cardInset = 14.0;
  static const sectionGap = 18.0;
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

  /// Ô nhập (Pencil Y4I0s8).
  static const fieldHeight = 52.0;

  /// Chip (Pencil HPjaU/trgwq) và nút viên thuốc nhỏ.
  static const chipHeight = 36.0;

  /// TopBar (Pencil qhcBT) và nút 44×44.
  static const topBarHeight = 56.0;
  static const iconButton = 44.0;

  /// TabBar (Pencil luKhc): cao 84 (gồm 20 đệm đáy), tab rộng 76, FAB 60.
  static const tabBarHeight = 84.0;
  static const tabItemWidth = 76.0;

  /// Tab của Circle shell (Pencil `LXpog`).
  static const circleTabItemWidth = 80.0;
  static const fabSize = 60.0;
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

  /// TabBar (Pencil luKhc): `#2E2A271F`, y −4, blur 24.
  static const tabBar = [
    BoxShadow(
      color: kColorShadow2E2A27Alpha12,
      blurRadius: 24,
      offset: Offset(0, -4),
    ),
  ];

  /// FAB tạo nhanh: `#EE7B6766`, y 6, blur 16.
  static const fab = [
    BoxShadow(
      color: kColorShadowPrimary500Alpha40,
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  /// FAB mở rộng (“Thêm nhiệm vụ”): `#C2513F40`, y 6, blur 16.
  static const extendedFab = [
    BoxShadow(
      color: kColorShadowPrimary600Alpha25,
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  /// Vòng tròn thành công CARE-06: `#6FAE8E66`, y 8, blur 20.
  static const success = [
    BoxShadow(
      color: kColorShadowSecondary500Alpha40,
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  /// Ô được chọn của SegmentedTabs: `#2E2A2714`, y 1, blur 4.
  static const segment = [
    BoxShadow(
      color: kColorShadow2E2A27Alpha08,
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];
}

abstract final class AppTheme {
  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: kColorDarkPrimary500F4917F,
      primary: kColorDarkPrimary600F7A796,
      onPrimary: kColorDarkPrimary502A1A16,
      primaryContainer: kColorDarkPrimary1003D231D,
      onPrimaryContainer: kColorDarkPrimary700FFC2B5,
      secondary: kColorDarkSecondary50086C3A3,
      onSecondary: kColorDarkSecondary1001C2B23,
      secondaryContainer: kColorDarkSecondary1001C2B23,
      onSecondaryContainer: kColorDarkSecondary700A9D9BF,
      error: kColorDarkErrorF08080,
      surface: kColorDarkSurface221E1B,
      onSurface: kColorDarkTextPrimaryF5EFEA,
      onSurfaceVariant: kColorDarkTextSecondaryBDB3AB,
      outline: kColorDarkBorder3A3430,
      surfaceContainerHighest: kColorDarkSurfaceVariant2C2724,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      fontFamily: AppTypography.bodyFamily,
      scaffoldBackgroundColor: kColorDarkBg171412,
      dividerColor: kColorDarkBorder3A3430,
      iconTheme: const IconThemeData(color: kColorDarkTextPrimaryF5EFEA),
      textTheme: ThemeData(brightness: Brightness.dark).textTheme.apply(
        fontFamily: AppTypography.bodyFamily,
        bodyColor: kColorDarkTextPrimaryF5EFEA,
        displayColor: kColorDarkTextPrimaryF5EFEA,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kColorDarkBg171412,
        surfaceTintColor: kColorTransparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: kColorDarkTextPrimaryF5EFEA,
        titleTextStyle: AppTypography.h3.copyWith(
          color: kColorDarkTextPrimaryF5EFEA,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: kColorDarkPrimary600F7A796,
          foregroundColor: kColorDarkPrimary502A1A16,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          textStyle: AppTypography.label,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kColorDarkPrimary600F7A796,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          textStyle: AppTypography.label,
          side: const BorderSide(color: kColorDarkPrimary600F7A796, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kColorDarkSurfaceVariant2C2724,
        hintStyle: AppTypography.body.copyWith(
          color: kColorDarkTextTertiary8A817A,
        ),
        labelStyle: AppTypography.caption.copyWith(
          color: kColorDarkTextSecondaryBDB3AB,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: kColorDarkBorder3A3430),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: kColorDarkPrimary500F4917F,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: kColorDarkErrorF08080),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: kColorDarkSurface221E1B,
        surfaceTintColor: kColorTransparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: kColorDarkSurfaceVariant2C2724,
        contentTextStyle: AppTypography.body.copyWith(
          color: kColorDarkTextPrimaryF5EFEA,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kColorDarkSurfaceVariant2C2724,
        selectedColor: kColorDarkPrimary1003D231D,
        labelStyle: AppTypography.caption.copyWith(
          color: kColorDarkTextPrimaryF5EFEA,
        ),
        side: const BorderSide(color: kColorDarkBorder3A3430),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }

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
      chipTheme: ChipThemeData(
        backgroundColor: kColorSurfaceFFFFFF,
        selectedColor: kColorPrimary50FFF4F1,
        showCheckmark: false,
        labelStyle: AppTypography.text14,
        side: const BorderSide(color: kColorBorderEADFD6),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3,
          vertical: AppSpacing.s2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
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
