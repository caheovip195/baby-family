part of '../mobile/auth_profile_mobile_view.dart';

/// Ô đồng ý: checkbox 24 bo 7 (chọn: nền `primary-600` + check 16), cách 12,
/// chữ 14 line-height 1.5 `text-primary`.
class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  final String label;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    checked: checked,
    button: true,
    child: InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.s6,
            height: AppSpacing.s6,
            decoration: BoxDecoration(
              color: checked
                  ? AppColors.resolve(context, kColorPrimary600C2513F)
                  : kColorTransparent,
              borderRadius: BorderRadius.circular(7),
              border: checked
                  ? null
                  : Border.all(
                      color: AppColors.resolve(context, kColorBorderEADFD6),
                      width: 2,
                    ),
            ),
            child: checked
                ? Icon(
                    LucideIcons.check,
                    size: 16,
                    color: AppColors.onPrimary(context),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Text(
              label,
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(height: 1.5),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
