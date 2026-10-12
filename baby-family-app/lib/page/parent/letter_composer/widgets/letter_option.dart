part of '../mobile/letter_composer_mobile_view.dart';

/// Ô lựa chọn MEM-14 (`W76aM5`, `hDtkp`): cao 40, bo 12. Thường: nền
/// `surface`, viền, chữ `text-secondary` 500. Chọn — [filled]: nền
/// `primary-600` chữ trắng 13/700 (Hẹn ngày mở); không [filled]: nền
/// `primary-50` viền `primary-500`, chữ `primary-700` 12/700 (Ai được đọc).
class _LetterOption extends StatelessWidget {
  const _LetterOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.filled = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final (background, border, foreground) = !selected
        ? (kColorSurfaceFFFFFF, kColorBorderEADFD6, kColorTextSecondary6B625B)
        : filled
        ? (kColorPrimary600C2513F, kColorPrimary600C2513F, kColorWhite)
        : (
            kColorPrimary50FFF4F1,
            kColorPrimary500EE7B67,
            kColorPrimary700A2402F,
          );
    final color = foreground == kColorWhite
        ? AppColors.onPrimary(context)
        : AppColors.resolve(context, foreground);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.tile),
      side: BorderSide(color: AppColors.resolve(context, border)),
    );
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.resolve(context, background),
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 14,
                      color: selected
                          ? AppColors.resolve(context, kColorPrimary600C2513F)
                          : color,
                    ),
                    const SizedBox(width: 5),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style:
                          (icon == null
                                  ? AppTypography.caption.copyWith(
                                      height: 16 / 13,
                                    )
                                  : AppTypography.small)
                              .copyWith(
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: color,
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
