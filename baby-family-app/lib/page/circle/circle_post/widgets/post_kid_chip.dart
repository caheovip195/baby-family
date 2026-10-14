part of '../mobile/circle_post_mobile_view.dart';

/// Chọn cháu (Pencil “Haru”/“Hana”): viên cao 60, đệm [0,16,0,8], avatar 44,
/// tên 18; đang chọn nền `primary-50` viền `primary-500`, chữ 700 +
/// `circle-check` 24 `primary-600`; khác nền `surface` viền `border`.
class _PostKidChip extends StatelessWidget {
  const _PostKidChip({
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
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 60),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s2,
                0,
                AppSpacing.s4,
                0,
              ),
              child: Row(
                children: [
                  ChildAvatar(child: child, borderWidth: 0),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      child.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.h3.copyWith(
                          fontFamily: AppTypography.bodyFamily,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  if (selected)
                    Icon(
                      LucideIcons.circleCheck,
                      size: 24,
                      color: AppColors.resolve(context, kColorPrimary600C2513F),
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
