part of '../mobile/invite_preview_mobile_view.dart';

/// Dòng quyền: icon 18 (`success`, hoặc `text-tertiary` khi [muted]) cách 10,
/// chữ 14 `text-secondary`; các dòng cách nhau 10.
class _VisibilityRow extends StatelessWidget {
  const _VisibilityRow({
    required this.icon,
    required this.label,
    this.muted = false,
  });

  final IconData icon;
  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1 + 1),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.resolve(
            context,
            muted ? kColorTextTertiary9C928A : kColorSuccess3E9B6E,
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Text(
            label,
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(color: kColorTextSecondary6B625B),
            ),
          ),
        ),
      ],
    ),
  );
}
