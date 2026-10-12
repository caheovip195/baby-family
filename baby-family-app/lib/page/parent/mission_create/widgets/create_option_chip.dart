part of '../mobile/mission_create_mobile_view.dart';

/// Ô lựa chọn CARE-03 (Pencil `KNz2P`, `hsrfU`): cao 44, bo 12. Chọn: nền
/// `primary-50` viền `primary-500`, chữ 13/700 `primary-700`; thường: nền
/// `surface` viền `border`, chữ 13/500 `text-secondary`. Có [icon] (Khi nào):
/// icon 16 `text-secondary` + chữ 13/600 `text-primary`.
class _CreateOptionChip extends StatelessWidget {
  const _CreateOptionChip({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final textColor = selected
        ? kColorPrimary700A2402F
        : (icon != null ? kColorTextPrimary2E2A27 : kColorTextSecondary6B625B);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary50FFF4F1 : kColorSurfaceFFFFFF,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.tile),
          side: BorderSide(
            color: AppColors.resolve(
              context,
              selected ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
            ),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.itemGap,
                vertical: AppSpacing.s1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 16,
                      color: AppColors.resolve(
                        context,
                        kColorTextSecondary6B625B,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.compact),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          height: 16 / 13,
                          fontWeight: selected
                              ? FontWeight.w700
                              : (icon != null
                                    ? FontWeight.w600
                                    : FontWeight.w500),
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
