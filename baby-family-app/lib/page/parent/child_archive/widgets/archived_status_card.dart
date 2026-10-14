part of '../mobile/child_archive_mobile_view.dart';

/// Bé đã lưu trữ (Pencil CHD-05b “Archived status”): avatar 44 mờ, “Khang
/// · đã lưu trữ” 14/600, “Lưu trữ 9 ngày · từ 28/09/2026” 12; nhãn “Đủ 7
/// ngày” (`secondary-100`, `check`) hoặc “Còn N ngày” khi chưa đủ.
class _ArchivedStatusCard extends StatelessWidget {
  const _ArchivedStatusCard({required this.controller});

  final ChildArchiveController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = controller.child!;
    final archivedAt = controller.info?.archivedAt;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Row(
        children: [
          Opacity(
            opacity: 0.6,
            child: ChildAvatar(child: child, size: 44, borderWidth: 0),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chdDeleteArchivedName(child.name),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.chdDeleteArchivedFor(
                    controller.archivedDays,
                    archivedAt?.toFormDate(l10n.localeName) ?? '',
                  ),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          if (controller.canDelete)
            AppTagPill(
              label: l10n.chdDeleteEnough(kValueChildDeleteAfterArchiveDays),
              icon: LucideIcons.check,
            )
          else
            AppTagPill(
              label: l10n.commonDaysLeft(controller.daysUntilDelete),
              icon: LucideIcons.hourglass,
              color: kColorAccent100FDF1D6,
              foreground: kColorAccent7009A6A12,
            ),
        ],
      ),
    );
  }
}
