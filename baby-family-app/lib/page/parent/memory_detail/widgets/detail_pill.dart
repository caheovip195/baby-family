part of '../mobile/memory_detail_mobile_view.dart';

/// Viên thông tin (`Ggjdz`, `cFOnf`): bo tròn, đệm ngang 10, cách 6; icon
/// hoặc chấm màu bé 8; chữ 12/600. Mặc định nền `surface-variant`, chữ
/// `text-secondary`, cao 30.
class _DetailPill extends StatelessWidget {
  const _DetailPill({
    required this.label,
    this.icon,
    this.dotColor,
    this.iconSize = 14,
    this.background = kColorSurfaceVariantF7F1EC,
    this.foreground = kColorTextSecondary6B625B,
    this.height = 30,
  });

  final String label;
  final IconData? icon;
  final Color? dotColor;
  final double iconSize;
  final Color background;
  final Color foreground;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, foreground);
    return Container(
      constraints: BoxConstraints(minHeight: height),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.itemGap,
        vertical: AppSpacing.s1,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, background),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: iconSize, color: color)
          else if (dotColor != null)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: AppSpacing.compact),
          Flexible(
            child: Text(
              label,
              style: AppTypography.small.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
