part of '../mobile/circle_home_mobile_view.dart';

/// Chip chọn cháu (Pencil `KIwM8`): cao 48, đệm trái 5 / phải 14, avatar 38
/// viền `surface`, tên 17. Đang chọn: nền `surface` + viền `primary-500` 2,
/// chữ 700; khác: nền `surface-variant`, chữ 500.
class _KidChip extends StatelessWidget {
  const _KidChip({
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
          selected ? kColorSurfaceFFFFFF : kColorSurfaceVariantF7F1EC,
        ),
        shape: StadiumBorder(
          side: selected
              ? BorderSide(
                  color: AppColors.resolve(context, kColorPrimary500EE7B67),
                  width: 2,
                )
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 14, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChildAvatar(
                    child: child,
                    size: 38,
                    borderColor: kColorSurfaceFFFFFF,
                    iconSize: 18,
                  ),
                  const SizedBox(width: AppSpacing.s2),
                  Text(
                    child.name,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.bodyLarge.copyWith(
                        height: 22 / 17,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
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
