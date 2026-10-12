import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Nút nổi dạng viên (Pencil US-06/US-07 “FAB”, CARE-07 “FAB Menu”): cao
/// [height] (48), đệm ngang 18 (16 khi thấp hơn 48), icon 18 + chữ 14/700.
/// Mặc định nền `us-700` chữ trắng; [color] `primary-600` (CARE-07 “Nhiệm
/// vụ”) hoặc `surface` + [bordered] (CARE-07 “Sự kiện”).
class AppExtendedFab extends StatelessWidget {
  const AppExtendedFab({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = kColorUs7006A549F,
    this.foreground,
    this.iconColor,
    this.height = 48,
    this.bordered = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  /// Màu chữ; null = chữ trên nền màu (trắng / nền tối khi dark mode).
  final Color? foreground;
  final Color? iconColor;
  final double height;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final fg = foreground == null
        ? AppColors.onPrimary(context)
        : AppColors.resolve(context, foreground!);
    return Material(
      color: AppColors.resolve(context, color),
      elevation: 2,
      shadowColor: kColorShadow2E2A27Alpha12,
      shape: StadiumBorder(
        side: bordered
            ? BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6))
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: height < 48 ? 16 : 18),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: iconColor == null
                    ? fg
                    : AppColors.resolve(context, iconColor!),
              ),
              const SizedBox(width: AppSpacing.s2),
              Text(
                label,
                style: AppTypography.text14.copyWith(
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
