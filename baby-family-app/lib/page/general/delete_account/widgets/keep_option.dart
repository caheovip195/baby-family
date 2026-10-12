part of '../mobile/delete_account_mobile_view.dart';

/// Lựa chọn giữ/xoá ký ức (Pencil `Gfyi2`): đệm 12, bo 12; đang chọn: nền
/// `primary-50`, viền `primary-300`, tiêu đề 14/700 + mô tả 12; chưa chọn:
/// viền `border`, tiêu đề 14/500. Vòng chọn 22.
class _KeepOption extends StatelessWidget {
  const _KeepOption({
    required this.title,
    required this.selected,
    required this.onTap,
    this.hint,
  });

  final String title;
  final String? hint;
  final bool selected;
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.tile),
          side: BorderSide(
            color: AppColors.resolve(
              context,
              selected ? kColorPrimary300F7A796 : kColorBorderEADFD6,
            ),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s3),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14.copyWith(
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (hint != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          hint!,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small.copyWith(height: 1.4),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                AppRadioMark(selected: selected, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
