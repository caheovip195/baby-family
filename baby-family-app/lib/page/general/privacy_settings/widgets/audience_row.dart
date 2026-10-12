part of '../mobile/privacy_settings_mobile_view.dart';

/// Dòng “Ai đang thấy bé nào” (Pencil `iwOGF`): chấm 10 màu bé, tên 14/600,
/// “3 người thân” / “Chỉ Papa & Mama” 13 `text-secondary`.
class _AudienceRow extends StatelessWidget {
  const _AudienceRow({
    required this.color,
    required this.name,
    required this.count,
  });

  final Color color;
  final String name;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.resolve(context, color),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Text(
            name,
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Text(
          count == 0 ? l10n.commonOnlyParents : l10n.setRelativeCount(count),
          style: AppTypography.adapt(context, AppTypography.caption),
        ),
      ],
    );
  }
}
