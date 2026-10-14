part of '../mobile/leave_family_mobile_view.dart';

/// Lựa chọn nội dung đã đăng (Pencil “Giữ lại cho gia đình” / “Gỡ toàn
/// bộ”): đệm 16 cách 12; ô icon 40 bo 12 (`surface` + `heart` `primary-600`
/// khi chọn, `surface-variant` khi không); tiêu đề 16/600 + mô tả 14; vòng
/// chọn 24; đang chọn nền `primary-50`.
class _LeaveChoice extends StatelessWidget {
  const _LeaveChoice({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
    this.divider = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final bool divider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected
            ? AppColors.resolve(context, kColorPrimary50FFF4F1)
            : kColorTransparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
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
                  width: AppSpacing.s10,
                  height: AppSpacing.s10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(
                      context,
                      selected
                          ? kColorSurfaceFFFFFF
                          : kColorSurfaceVariantF7F1EC,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: AppColors.resolve(
                      context,
                      selected
                          ? kColorPrimary600C2513F
                          : kColorTextSecondary6B625B,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.title16.copyWith(
                            fontFamily: AppTypography.bodyFamily,
                            fontWeight: FontWeight.w600,
                            height: 20 / 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14.copyWith(
                            height: 20 / 14,
                            color: kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                AppRadioMark(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
