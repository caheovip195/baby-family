part of '../mobile/child_archive_mobile_view.dart';

/// Một tác động (Pencil “Effect”): icon 18 + chữ 14 `text-primary`, cách
/// 10; các dòng cách nhau 12.
class _ArchiveEffectRow extends StatelessWidget {
  const _ArchiveEffectRow({
    required this.icon,
    required this.text,
    this.iconColor = kColorTextSecondary6B625B,
    this.last = false,
  });

  final IconData icon;
  final String text;
  final Color iconColor;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : AppSpacing.s3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.resolve(context, iconColor),
            ),
          ),
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
    );
  }
}
