part of '../mobile/letter_composer_mobile_view.dart';

/// Chip người nhận (`K6cWg`): cao 40, đệm 4/14/4/4, cách 8, bo tròn; avatar
/// 32 + tên 14/500. Đang chọn: nền `primary-50`, viền `primary-500`, tên
/// 14/700 `primary-700` + `check` 16 `primary-600`; khác: nền `surface`, viền.
class _LetterRecipientChip extends StatelessWidget {
  const _LetterRecipientChip({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  final Child child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary50FFF4F1 : kColorSurfaceFFFFFF,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: AppColors.resolve(
              context,
              selected ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
            ),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 14, 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChildAvatar(child: child, size: 32, borderWidth: 0),
                const SizedBox(width: AppSpacing.s2),
                Text(
                  child.name,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? kColorPrimary700A2402F
                          : kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: AppSpacing.s2),
                  Icon(
                    LucideIcons.check,
                    size: 16,
                    color: AppColors.resolve(context, kColorPrimary600C2513F),
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
