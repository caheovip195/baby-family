part of '../mobile/memory_quote_mobile_view.dart';

/// Nút tuỳ chọn (`N4MS8`, `GOmJh`): cao 44, bo 14, icon 16 + chữ 13
/// (ghi âm: nền `secondary-100` 13/700; người xem: `surface-variant` 13/600).
class _QuoteOption extends StatelessWidget {
  const _QuoteOption({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.bold = false,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, foreground);
    return Material(
      color: AppColors.resolve(context, background),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.iconButton),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s2,
              vertical: AppSpacing.s1,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: AppSpacing.s2),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(
                      fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                      height: 16 / 13,
                      color: color,
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
