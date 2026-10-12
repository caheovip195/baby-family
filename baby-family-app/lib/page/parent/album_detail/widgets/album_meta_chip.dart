part of '../mobile/album_detail_mobile_view.dart';

/// Chip meta album (`f0Cr5U`): cao 28, đệm ngang 10, cách 5, bo tròn; icon
/// 14 + chữ 12/600 cùng màu [foreground].
class _AlbumMetaChip extends StatelessWidget {
  const _AlbumMetaChip({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, foreground);
    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.itemGap),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, background),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
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
