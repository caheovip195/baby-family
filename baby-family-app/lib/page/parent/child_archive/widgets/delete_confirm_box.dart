part of '../mobile/child_archive_mobile_view.dart';

/// Xác nhận 1/2 (Pencil CHD-05b “Confirm 1”): ô bo 14 đệm 14, đã chọn →
/// nền `primary-50` viền `primary-300`; ô đánh dấu 22 + chữ 14.
class _DeleteConfirmBox extends StatelessWidget {
  const _DeleteConfirmBox({
    required this.checked,
    required this.text,
    required this.onTap,
  });

  final bool checked;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    return Semantics(
      checked: checked,
      child: Material(
        color: AppColors.resolve(
          context,
          checked ? kColorPrimary50FFF4F1 : kColorSurfaceFFFFFF,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: AppColors.resolve(
              context,
              checked ? kColorPrimary300F7A796 : kColorBorderEADFD6,
            ),
          ),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: radius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardInset),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCheckMark(checked: checked),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Text(
                    text,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(height: 20 / 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
