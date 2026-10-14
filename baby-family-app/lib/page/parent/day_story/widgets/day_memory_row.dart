part of '../mobile/day_story_mobile_view.dart';

/// Một ký ức trong ngày (`XjVTq`): đệm dọc 10, cách 10; ô tick 22 bo 7
/// (`primary-500` + `check` 14 trắng / `surface` viền); tiêu đề 13/600 (chưa
/// tick: `text-secondary`) + “Ảnh · 09:40” 11; ô loại 30 bo 10 `primary-50`
/// (icon 15 `primary-600`). [divider]: kẻ dưới.
class _DayMemoryRow extends StatelessWidget {
  const _DayMemoryRow({
    required this.item,
    required this.divider,
    required this.onTap,
  });

  final DayStoryItem item;
  final bool divider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = item.selected;
    return Semantics(
      checked: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
          decoration: divider
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.resolve(context, kColorBorderEADFD6),
                    ),
                  ),
                )
              : null,
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.resolve(
                    context,
                    selected ? kColorPrimary500EE7B67 : kColorSurfaceFFFFFF,
                  ),
                  borderRadius: BorderRadius.circular(7),
                  border: selected
                      ? null
                      : Border.all(
                          color: AppColors.resolve(context, kColorBorderEADFD6),
                        ),
                ),
                child: selected
                    ? const Icon(
                        LucideIcons.check,
                        size: 14,
                        color: kColorWhite,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          color: selected
                              ? kColorTextPrimary2E2A27
                              : kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      l10n.recapDayItemMeta(item.kindCode, item.time ?? ''),
                      style: AppTypography.adapt(context, AppTypography.tiny),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorPrimary50FFF4F1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  lucideIconByName(item.icon),
                  size: 15,
                  color: AppColors.resolve(context, kColorPrimary600C2513F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
