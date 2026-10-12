import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Thẻ nội dung (Pencil “Today Card”, “This Week”, “Group Card”): nền
/// `surface`, viền 1 `border`, bo 16, đệm 14. Đổi [color]/[borderColor] cho
/// thẻ tô màu (`us-50`/`us-100` Papa & Mama, `accent-100` ngày đặc biệt,
/// `secondary-100` cây). [borderColor] = null → không viền.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.cardInset),
    this.radius = AppRadius.lg,
    this.color = kColorSurfaceFFFFFF,
    this.borderColor = kColorBorderEADFD6,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.resolve(context, color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: borderColor == null
            ? BorderSide.none
            : BorderSide(color: AppColors.resolve(context, borderColor!)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
