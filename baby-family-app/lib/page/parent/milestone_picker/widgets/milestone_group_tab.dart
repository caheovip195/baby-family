part of '../mobile/milestone_picker_mobile_view.dart';

/// Tab nhóm cột mốc (`xpQvi`): cao 34, đệm ngang 12, bo tròn. Đang chọn: nền
/// `primary-600`, chữ 13/700 trắng; khác: nền `surface`, viền, 13/500
/// `text-secondary`.
class _MilestoneGroupTab extends StatelessWidget {
  const _MilestoneGroupTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
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
          selected ? kColorPrimary600C2513F : kColorSurfaceFFFFFF,
        ),
        shape: StadiumBorder(
          side: selected
              ? BorderSide.none
              : BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 34),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    height: 16 / 13,
                    color: selected
                        ? AppColors.onPrimary(context)
                        : AppColors.resolve(context, kColorTextSecondary6B625B),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
