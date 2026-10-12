part of '../mobile/thanks_wall_mobile_view.dart';

/// Chú thích màu (Pencil `XKhkg`): ô màu 14 bo 4 + chữ 12/600, cách 14; số lời
/// cảm ơn 12 `text-tertiary` bên phải.
class _ThanksLegend extends StatelessWidget {
  const _ThanksLegend({required this.partnerCallName, required this.count});

  final String partnerCallName;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget swatch(bool mine, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: _noteColor(context, mine: mine),
            borderRadius: BorderRadius.circular(AppSpacing.s1),
            border: Border.all(
              color: AppColors.resolve(context, kColorBorderEADFD6),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.compact),
        Text(
          label,
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: AppSpacing.cardInset,
            runSpacing: AppSpacing.s1,
            children: [
              swatch(true, l10n.usThanksMine),
              swatch(false, l10n.usThanksPartner(partnerCallName)),
            ],
          ),
        ),
        Text(
          l10n.usThanksCount(count),
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
          ),
        ),
      ],
    );
  }
}
