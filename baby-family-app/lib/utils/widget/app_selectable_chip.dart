import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Selection pills for mood needs, request timing and child filters.
class AppSelectableChip extends StatelessWidget {
  const AppSelectableChip({
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.prefix,
    this.suffix,
    this.height = 36,
    this.radius = AppRadius.full,
    this.filledSelection = true,
    this.outlined = false,
    this.fontSize = 13,
    this.padding = AppSpacing.cardInset,
    this.insets,
    this.prefixGap = AppSpacing.compact,
    this.textColor,
    super.key,
  });
  final String label;
  final VoidCallback onPressed;
  final bool selected;
  final Widget? prefix;

  /// Nhãn phụ sau chữ (US-12 “Lời nhờ”), cách [prefixGap].
  final Widget? suffix;
  final double height;
  final double radius;
  final bool filledSelection;
  final bool outlined;
  final double fontSize;
  final double padding;
  final EdgeInsetsGeometry? insets;
  final double prefixGap;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    final foreground = textColor != null
        ? AppColors.resolve(context, textColor!)
        : selected
        ? (filledSelection
              ? AppColors.onPrimary(context)
              : AppColors.resolve(context, kColorUs7006A549F))
        : AppColors.resolve(context, kColorTextSecondary6B625B);
    return Semantics(
      selected: selected,
      button: true,
      child: SizedBox(
        height: height,
        child: Material(
          color: AppColors.resolve(
            context,
            selected
                ? (filledSelection ? kColorUs7006A549F : kColorUs100EAE2F8)
                : (outlined ? kColorSurfaceFFFFFF : kColorSurfaceVariantF7F1EC),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: selected && !filledSelection
                ? BorderSide(
                    color: AppColors.resolve(context, kColorUs5009B85D1),
                  )
                : outlined
                ? BorderSide(
                    color: AppColors.resolve(context, kColorUs100EAE2F8),
                  )
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: insets ?? EdgeInsets.symmetric(horizontal: padding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefix != null) ...[prefix!, SizedBox(width: prefixGap)],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      style: AppTypography.caption.copyWith(
                        fontSize: fontSize,
                        height: 16 / 13,
                        fontWeight: FontWeight.w600,
                        color: foreground,
                      ),
                    ),
                  ),
                  if (suffix != null) ...[SizedBox(width: prefixGap), suffix!],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
