part of '../mobile/mission_history_mobile_view.dart';

/// Chip lọc CARE-08 (Pencil `PjlTJ`): cao 36 bo tròn; đang chọn nền
/// `text-primary` chữ `bg` 13/700; thường nền `surface` viền `border` chữ
/// 13/500. Có avatar 30 (đệm 3/12/3/3) hoặc `chevron-down` 14 (“Loại”).
class _HistoryFilterChip extends StatelessWidget {
  const _HistoryFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.avatar,
    this.dropdown = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? avatar;
  final bool dropdown;

  @override
  Widget build(BuildContext context) {
    final foreground = AppColors.resolve(
      context,
      selected ? kColorBgFFFBF7 : kColorTextPrimary2E2A27,
    );
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorTextPrimary2E2A27 : kColorSurfaceFFFFFF,
        ),
        shape: StadiumBorder(
          side: selected
              ? BorderSide.none
              : BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: AppSpacing.chipHeight,
            padding: EdgeInsets.fromLTRB(
              avatar == null ? AppSpacing.s3 : 3,
              3,
              dropdown ? AppSpacing.itemGap : AppSpacing.s3,
              3,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (avatar != null) ...[
                  avatar!,
                  const SizedBox(width: AppSpacing.compact),
                ],
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    height: 16 / 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: foreground,
                  ),
                ),
                if (dropdown) ...[
                  const SizedBox(width: AppSpacing.s1),
                  Icon(
                    LucideIcons.chevronDown,
                    size: 14,
                    color: selected
                        ? foreground
                        : AppColors.resolve(context, kColorTextSecondary6B625B),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
