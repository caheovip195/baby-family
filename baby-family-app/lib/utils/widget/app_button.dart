import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

import 'loading_progress.dart';

/// Nút 52px của Design System (Pencil ButtonPrimary `j4Xas`, ButtonSecondary
/// `gRWxn`, ButtonSocial `Ky5HH`): bo 16, chữ 15/600 Be Vietnam Pro, icon 20.
///
/// - [AppButton] — nền `primary-600`, chữ `on-primary`.
/// - [AppButton.secondary] — viền 1.5 `primary-600`, chữ `primary-600`.
/// - [AppButton.social] — nền `surface`, viền `border`, icon + chữ
///   `text-primary` (AUTH-01 Apple/Google/Phone).
/// - [AppButton.us] — nền `us-700` cho vùng Papa & Mama.
/// - [AppButton.text] — chỉ chữ (“Để sau”, “Gợi ý khác”).
/// - Nút nguy hiểm (xoá): [AppButton] với `color: kColorErrorD14B4B`.
///
/// Mặc định giãn hết chiều ngang ([expand] = true) như Pencil (350 = 390 − 2×20).
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = true,
    this.height = AppSpacing.buttonHeight,
    this.fontSize = 15,
    this.color = kColorPrimary600C2513F,
  }) : _style = AppButtonStyle.primary,
       borderColor = null,
       iconColor = null,
       inverted = false;

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = true,
    this.height = AppSpacing.buttonHeight,
    this.fontSize = 15,
    this.color = kColorPrimary600C2513F,
    this.borderColor,
  }) : _style = AppButtonStyle.secondary,
       iconColor = null,
       inverted = false;

  const AppButton.social({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = true,
    this.height = AppSpacing.buttonHeight,
    this.fontSize = 15,
    this.iconColor,
    this.inverted = false,
  }) : _style = AppButtonStyle.social,
       color = kColorTextPrimary2E2A27,
       borderColor = kColorBorderEADFD6;

  const AppButton.us({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = true,
    this.height = AppSpacing.buttonHeight,
    this.fontSize = 15,
  }) : _style = AppButtonStyle.us,
       color = kColorUs7006A549F,
       borderColor = null,
       iconColor = null,
       inverted = false;

  const AppButton.text({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = true,
    this.height = AppSpacing.buttonHeight,
    this.fontSize = 15,
    this.color = kColorPrimary600C2513F,
  }) : _style = AppButtonStyle.text,
       borderColor = null,
       iconColor = null,
       inverted = false;

  final Color color;
  final Color? borderColor;
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  /// Chiều cao (mặc định 52; CIR-WAIT dùng 60 cho người lớn tuổi).
  final double height;

  /// Cỡ chữ nhãn (mặc định 15; CIR-WAIT 17).
  final double fontSize;

  /// [AppButton.social]: màu icon riêng (CIR-WAIT “Nhờ con mời mình”).
  final Color? iconColor;

  /// [AppButton.social]: nền `text-primary`, chữ/icon trắng (AUTH-01 Apple).
  final bool inverted;
  final AppButtonStyle _style;

  bool get _filled =>
      _style == AppButtonStyle.primary || _style == AppButtonStyle.us;

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final foreground = _filled
        ? AppColors.onPrimary(context)
        : inverted
        ? (dark ? AppColors.darkToken(kColorBgFFFBF7) : kColorWhite)
        : AppColors.resolve(context, color);
    final background = switch (_style) {
      AppButtonStyle.primary ||
      AppButtonStyle.us => AppColors.resolve(context, color),
      AppButtonStyle.social => AppColors.resolve(
        context,
        inverted ? kColorTextPrimary2E2A27 : kColorSurfaceFFFFFF,
      ),
      AppButtonStyle.secondary || AppButtonStyle.text => kColorTransparent,
    };
    final side = switch (_style) {
      AppButtonStyle.secondary => BorderSide(
        color: AppColors.resolve(context, borderColor ?? color),
        width: 1.5,
      ),
      AppButtonStyle.social => BorderSide(
        color: AppColors.resolve(
          context,
          inverted
              ? kColorTextPrimary2E2A27
              : borderColor ?? kColorBorderEADFD6,
        ),
      ),
      _ => BorderSide.none,
    };
    final content = isLoading
        ? CircleLoadingProgress(color: foreground)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: iconColor == null
                      ? foreground
                      : AppColors.resolve(context, iconColor!),
                ),
                SizedBox(
                  width: _style == AppButtonStyle.social
                      ? AppSpacing.itemGap
                      : AppSpacing.s2,
                ),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(
                    color: foreground,
                    fontSize: fontSize,
                    height: 20 / 15,
                  ),
                ),
              ),
            ],
          );
    final disabled = onPressed == null && !isLoading;
    return Semantics(
      button: true,
      enabled: !disabled,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Material(
          color: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: side,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: height,
                minWidth: expand ? double.infinity : 0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
                child: Center(widthFactor: 1, child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
