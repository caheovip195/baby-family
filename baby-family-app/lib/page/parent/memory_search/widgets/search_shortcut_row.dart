part of '../mobile/memory_search_mobile_view.dart';

/// Lối tắt khi chưa tìm: icon 18 trong ô 36 `primary-50` + nhãn 15/600 +
/// `chevron-right` 18 — mở MEM-16 Ngày này năm xưa / MEM-03 Album / MEM-19 Ảnh chờ duyệt /
/// MEM-18 Nháp / MEM-17 Thùng rác.
class _SearchShortcutRow extends StatelessWidget {
  const _SearchShortcutRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardInset,
          vertical: AppSpacing.s2,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorPrimary50FFF4F1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                icon,
                size: 18,
                color: AppColors.resolve(context, kColorPrimary600C2513F),
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                label,
                style: AppTypography.adapt(context, AppTypography.bodyStrong),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: AppColors.resolve(context, kColorTextTertiary9C928A),
            ),
          ],
        ),
      ),
    );
  }
}
