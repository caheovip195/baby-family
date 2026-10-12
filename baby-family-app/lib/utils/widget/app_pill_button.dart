import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Compact actions in Pencil cards; independent from 52px form buttons.
class AppPillButton extends StatelessWidget {
  const AppPillButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = kColorSurfaceFFFFFF,
    this.foreground = kColorUs7006A549F,
    this.height = 36,
    this.fontSize = 13,
    this.outlined = false,
    this.horizontalPadding = AppSpacing.cardInset,
    this.iconSize = 16,
    this.borderColor = kColorBorderEADFD6,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final Color foreground;
  final double height;
  final double fontSize;
  final bool outlined;
  final double horizontalPadding;
  final double iconSize;
  final Color borderColor;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size(0, height),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        backgroundColor: AppColors.resolve(context, color),
        foregroundColor: AppColors.resolve(context, foreground),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
          side: outlined
              ? BorderSide(color: AppColors.resolve(context, borderColor))
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize),
            const SizedBox(width: AppSpacing.compact),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                fontSize: fontSize,
                height: 16 / 13,
                fontWeight: FontWeight.w600,
                color: AppColors.resolve(context, foreground),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
