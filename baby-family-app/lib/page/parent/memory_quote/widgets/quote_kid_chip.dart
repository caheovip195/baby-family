part of '../mobile/memory_quote_mobile_view.dart';

/// Chip bé (`EZimc`): cao 36, đệm 0/12/0/4, cách 8, bo tròn; avatar 28;
/// tên 13/700. Chọn: nền `primary-100`, viền `primary-500`, chữ
/// `primary-700`; chưa chọn: nền `surface-variant`, chữ `text-secondary`.
class _QuoteKidChip extends StatelessWidget {
  const _QuoteKidChip({
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
          selected ? kColorPrimary100FFE3DC : kColorSurfaceVariantF7F1EC,
        ),
        shape: StadiumBorder(
          side: selected
              ? BorderSide(
                  color: AppColors.resolve(context, kColorPrimary500EE7B67),
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSpacing.chipHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s1,
                AppSpacing.s1,
                AppSpacing.s3,
                AppSpacing.s1,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChildAvatar(child: child, size: 28, borderWidth: 0),
                  const SizedBox(width: AppSpacing.s2),
                  Text(
                    child.name,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 16 / 13,
                        color: selected
                            ? kColorPrimary700A2402F
                            : kColorTextSecondary6B625B,
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
