import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Shared content surface for Home, Care, Family and Papa & Mama.
class AppPanel extends StatelessWidget {
  const AppPanel({
    required this.child,
    this.color = kColorSurfaceFFFFFF,
    this.padding = AppSpacing.s4,
    this.radius = AppRadius.xl,
    this.borderColor,
    this.borderWidth = 1,
    super.key,
  });
  final Widget child;
  final Color color;
  final double padding;
  final double radius;
  final Color? borderColor;
  final double borderWidth;
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.resolve(context, color),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: borderColor != null
          ? BorderSide(
              color: AppColors.resolve(context, borderColor!),
              width: borderWidth,
            )
          : AppColors.isDark(context)
          ? const BorderSide(color: kColorDarkBorder3A3430)
          : BorderSide.none,
    ),
    child: SizedBox(
      width: double.infinity,
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    ),
  );
}
