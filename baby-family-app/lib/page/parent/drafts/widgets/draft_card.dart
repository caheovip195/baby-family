part of '../mobile/drafts_mobile_view.dart';

/// Một bản nháp (Pencil “Haru đi giày mới”): thẻ `surface` viền `border` bo
/// 16 đệm 14 cách 12; ảnh 60 (nhãn “+3”) hoặc ô loại; tiêu đề 15/600, dòng
/// phụ 12 `text-secondary`; nút viên 34 “Tiếp tục soạn” (`primary-50`, viền
/// `primary-300`) và “Xoá” (viền `border`).
class _DraftCard extends StatelessWidget {
  const _DraftCard({
    required this.draft,
    required this.meta,
    required this.onResume,
    required this.onDelete,
  });

  final MemoryDraftItem draft;
  final String meta;
  final VoidCallback onResume;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
          MemoryThumb(
            kind: draft.kind,
            asset: draft.mediaAssets.firstOrNull,
            size: 60,
            extraCount: draft.extraCount,
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  draft.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.bodyStrong.copyWith(height: 19 / 15),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  meta,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.compact + 3),
                Wrap(
                  spacing: AppSpacing.s2,
                  runSpacing: AppSpacing.s2,
                  children: [
                    AppPillButton(
                      label: l10n.memDraftContinue,
                      icon: LucideIcons.pencil,
                      iconSize: 14,
                      height: 34,
                      horizontalPadding: AppSpacing.s3,
                      color: kColorPrimary50FFF4F1,
                      foreground: kColorPrimary700A2402F,
                      outlined: true,
                      borderColor: kColorPrimary300F7A796,
                      onPressed: onResume,
                    ),
                    AppPillButton(
                      label: l10n.commonDelete,
                      icon: LucideIcons.trash2,
                      iconSize: 14,
                      height: 34,
                      horizontalPadding: AppSpacing.s3,
                      color: kColorTransparent,
                      foreground: kColorTextSecondary6B625B,
                      outlined: true,
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
