part of '../mobile/couple_week_mobile_view.dart';

/// “Một lời cảm ơn trong tuần” (`lOlYs`): nền `accent-100` bo 16, đệm 14,
/// cách 6; nhãn 11/700 `text-secondary`; câu 14 (dòng 1.4); meta 11.
class _WeekThanksCard extends StatelessWidget {
  const _WeekThanksCard({required this.quote, required this.meta});

  final String quote;
  final String meta;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorAccent100FDF1D6),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.usCoupleWeekThanksKicker,
            style: AppTypography.adapt(
              context,
              AppTypography.tiny.copyWith(
                fontWeight: FontWeight.w700,
                color: kColorTextSecondary6B625B,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(
            l10n.commonQuoted(quote),
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(height: 1.4),
            ),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(meta, style: AppTypography.adapt(context, AppTypography.tiny)),
        ],
      ),
    );
  }
}
