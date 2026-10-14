part of '../mobile/child_archive_mobile_view.dart';

/// Bé sắp lưu trữ (Pencil CHD-05 “Child Card”): thẻ `surface` viền bo 16
/// đệm 14; avatar 48, tên 18/800, “Sinh 08/04/2025 · Papa thêm ngày
/// 02/10/2026” 12, nhãn “Có thể trùng với Haru”.
class _ArchiveChildCard extends StatelessWidget {
  const _ArchiveChildCard({required this.controller});

  final ChildArchiveController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = controller.child!;
    final info = controller.info!;
    final locale = l10n.localeName;
    final birth = child.birthDate?.toFormDate(locale) ?? '';
    final addedBy = controller.addedByName;
    final addedAt = info.addedAt;
    final duplicate = controller.duplicateName;
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
          ChildAvatar(child: child, size: 48, borderWidth: 0),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  addedBy != null && addedAt != null
                      ? l10n.chdArchiveAddedBy(
                          birth,
                          addedBy,
                          addedAt.toFormDate(locale),
                        )
                      : l10n.chdArchiveBorn(birth),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
                if (duplicate != null) ...[
                  const SizedBox(height: 3),
                  AppTagPill(
                    label: l10n.chdArchiveDuplicate(duplicate),
                    icon: LucideIcons.copy,
                    dense: true,
                    color: kColorAccent100FDF1D6,
                    foreground: kColorAccent7009A6A12,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
