part of '../mobile/on_this_day_mobile_view.dart';

/// Thẻ câu nói năm xưa (`Td85r`): nền `primary-50` bo 16, đệm 14/16, cách 4;
/// câu nói 20/800 `primary-700`, meta 12 `text-secondary`.
class _PastQuoteCard extends StatelessWidget {
  const _PastQuoteCard({
    required this.quote,
    required this.meta,
    required this.onTap,
  });

  final String quote;
  final String meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.resolve(context, kColorPrimary50FFF4F1),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.cardInset,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quote,
                style: AppTypography.title20.copyWith(
                  color: AppColors.resolve(context, kColorPrimary700A2402F),
                ),
              ),
              const SizedBox(height: AppSpacing.s1),
              Text(
                meta,
                style: AppTypography.adapt(context, AppTypography.small),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
