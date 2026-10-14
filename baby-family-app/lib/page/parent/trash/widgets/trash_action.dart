part of '../mobile/trash_mobile_view.dart';

/// Nút 40 bo 12 của thẻ thùng rác: “Khôi phục” nền `secondary-100`, “Xoá
/// vĩnh viễn” viền `border` chữ `error`; icon 16 + chữ 14/600.
class _TrashAction extends StatelessWidget {
  const _TrashAction({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color foreground;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = AppColors.resolve(context, foreground);
    final radius = BorderRadius.circular(AppRadius.tile);
    return Material(
      color: color == null
          ? kColorTransparent
          : AppColors.resolve(context, color!),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: color == null
            ? BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6))
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(borderRadius: radius),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.s10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: AppSpacing.compact),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
