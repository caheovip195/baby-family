part of '../mobile/album_detail_mobile_view.dart';

/// Dòng menu ⋯ (`ERdZ5`): cao 42+, đệm ngang 12, icon 18 `text-secondary`
/// (xoá: `error`), chữ 14/500; [note] 11 `text-tertiary` thụt 40 dưới dòng.
class _AlbumMenuItem extends StatelessWidget {
  const _AlbumMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.note,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? note;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(
      context,
      destructive ? kColorErrorD14B4B : kColorTextPrimary2E2A27,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3,
          vertical: AppSpacing.s3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: destructive
                      ? color
                      : AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.text14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            if (note != null)
              Padding(
                padding: const EdgeInsets.only(left: 28, top: AppSpacing.s1),
                child: Text(
                  note!,
                  style: AppTypography.adapt(context, AppTypography.tiny),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
