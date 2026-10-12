part of '../mobile/memory_search_mobile_view.dart';

/// Chip lọc MEM-15 (`M7amz`): cao 34, bo tròn, cách 4. Thường: nền `surface`,
/// viền, 12/500 `text-secondary` + `chevron-down` 14 `text-tertiary`; đang
/// lọc: nền `primary-50`, viền `primary-500`, 12/700 `primary-700`, chevron
/// `primary-600`. [recent] = chip “Gần đây” cao 28 nền `surface-variant` có
/// icon `history` 12, không chevron.
class _SearchFilterChip extends StatelessWidget {
  const _SearchFilterChip({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.icon,
    this.avatar,
    this.recent = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;
  final IconData? icon;
  final Widget? avatar;
  final bool recent;

  @override
  Widget build(BuildContext context) {
    final (background, border, foreground, chevron) = recent
        ? (
            kColorSurfaceVariantF7F1EC,
            kColorSurfaceVariantF7F1EC,
            kColorTextSecondary6B625B,
            kColorTextTertiary9C928A,
          )
        : selected
        ? (
            kColorPrimary50FFF4F1,
            kColorPrimary500EE7B67,
            kColorPrimary700A2402F,
            kColorPrimary600C2513F,
          )
        : (
            kColorSurfaceFFFFFF,
            kColorBorderEADFD6,
            kColorTextSecondary6B625B,
            kColorTextTertiary9C928A,
          );
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.resolve(context, background),
        shape: StadiumBorder(
          side: recent
              ? BorderSide.none
              : BorderSide(color: AppColors.resolve(context, border)),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: recent ? 28 : 34),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                avatar != null ? AppSpacing.s1 : AppSpacing.itemGap,
                AppSpacing.s1,
                recent ? AppSpacing.itemGap : AppSpacing.s2,
                AppSpacing.s1,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (avatar != null) ...[
                    avatar!,
                    const SizedBox(width: AppSpacing.s1),
                  ],
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 12,
                      color: AppColors.resolve(
                        context,
                        kColorTextTertiary9C928A,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s1),
                  ],
                  Text(
                    label,
                    style: AppTypography.small.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.resolve(context, foreground),
                    ),
                  ),
                  if (!recent) ...[
                    const SizedBox(width: AppSpacing.s1),
                    Icon(
                      LucideIcons.chevronDown,
                      size: 14,
                      color: AppColors.resolve(context, chevron),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
