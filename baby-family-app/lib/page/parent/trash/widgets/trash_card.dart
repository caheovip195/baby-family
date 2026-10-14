part of '../mobile/trash_mobile_view.dart';

/// Ký ức trong thùng rác (Pencil “Haru ngủ trưa ở nhà bà”): thẻ `surface`
/// viền `border` bo 16 đệm 14 cách 12; ảnh 64 bo 12 + tiêu đề 15/600, dòng
/// phụ 12 `text-secondary`, “Mama xoá 30/09 ·” 12 `text-tertiary` + nhãn
/// “Còn 23 ngày” (≤ 3 ngày: tông đỏ); hai nút Khôi phục / Xoá vĩnh viễn.
class _TrashCard extends StatelessWidget {
  const _TrashCard({
    required this.memory,
    required this.meta,
    required this.deletedBy,
    required this.daysLeft,
    required this.onRestore,
    required this.onDelete,
  });

  /// Còn ≤ 3 ngày → nhãn đỏ (Pencil “Còn 3 ngày”).
  static const _urgentDays = 3;

  final Memory memory;
  final String meta;
  final String deletedBy;
  final int daysLeft;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final urgent = daysLeft <= _urgentDays;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              MemoryThumb(
                kind: memory.kind,
                asset: memory.mediaAssets.firstOrNull,
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memoryTitle(memory),
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
                    const SizedBox(height: 3),
                    Wrap(
                      spacing: AppSpacing.compact,
                      runSpacing: AppSpacing.s1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          deletedBy,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small.copyWith(
                              color: kColorTextTertiary9C928A,
                            ),
                          ),
                        ),
                        AppTagPill(
                          label: l10n.commonDaysLeft(daysLeft),
                          icon: LucideIcons.hourglass,
                          dense: true,
                          color: urgent
                              ? kColorError50FBE4E4
                              : kColorAccent100FDF1D6,
                          foreground: urgent
                              ? kColorErrorD14B4B
                              : kColorAccent7009A6A12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: _TrashAction(
                  icon: LucideIcons.rotateCcw,
                  label: l10n.childRestore,
                  color: kColorSecondary100E4F2EA,
                  foreground: kColorSecondary7003F7A5C,
                  onTap: onRestore,
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: _TrashAction(
                  icon: LucideIcons.trash2,
                  label: l10n.commonDeleteForever,
                  foreground: kColorErrorD14B4B,
                  onTap: onDelete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
