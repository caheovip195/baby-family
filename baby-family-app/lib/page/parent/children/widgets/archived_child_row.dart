part of '../mobile/children_mobile_view.dart';

/// Bé đã lưu trữ (Pencil `a50Sm8`): nền `surface-variant` bo 16 đệm 12/14
/// cách 12; vòng 44 nền `border` (`archive` 20), tên 14/600 `text-secondary`,
/// “Lưu trữ 02/10/2026 · 0 ký ức riêng” 12 `text-tertiary`, nút “Khôi phục” 32.
class _ArchivedChildRow extends StatelessWidget {
  const _ArchivedChildRow({
    required this.child,
    required this.privateCount,
    required this.onRestore,
    this.onTap,
  });

  /// Mở CHD-05b (xoá vĩnh viễn sau 7 ngày lưu trữ).
  final VoidCallback? onTap;

  final Child child;
  final int privateCount;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final archivedAt = child.archivedAt;
    final meta = [
      if (archivedAt != null)
        l10n.childArchivedOn(archivedAt.toFormDate(l10n.localeName)),
      l10n.childPrivateMemories(privateCount),
    ].reduce(l10n.commonDotJoin);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardInset,
          vertical: AppSpacing.s3,
        ),
        decoration: BoxDecoration(
          color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
              child: Icon(
                LucideIcons.archive,
                size: 20,
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: kColorTextSecondary6B625B,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        color: kColorTextTertiary9C928A,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Material(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              shape: StadiumBorder(
                side: BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onRestore,
                child: Container(
                  height: 32,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s3,
                  ),
                  child: Text(
                    l10n.childRestore,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
