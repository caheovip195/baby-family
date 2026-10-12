part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Nhãn tuần (Pencil `afGyu`): huy hiệu “Tuần 24” (đệm 4/10, `us-700`, chữ
/// 12/800), mô tả 12 `text-secondary`, đường kẻ 1 `border`; cách 10.
class _WeekHeader extends StatelessWidget {
  const _WeekHeader({required this.week});

  final PregnancyTimelineWeek week;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final caption = week.isCurrent
        ? l10n.pregWeekThis
        : week.hasFirst
        ? l10n.pregWeekFirsts
        : l10n.memoriesCount(week.memoryCount);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.itemGap,
            vertical: AppSpacing.s1,
          ),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorUs7006A549F),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            l10n.commonPregnancyWeekOnly(week.week),
            style: AppTypography.small.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.onPrimary(context),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Text(caption, style: AppTypography.adapt(context, AppTypography.small)),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
        ),
      ],
    );
  }
}
