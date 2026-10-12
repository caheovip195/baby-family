part of '../mobile/family_tree_mobile_view.dart';

/// Lịch sử Hearts của tôi (Pencil `DYLhu`): nền `surface` bo 20, đệm 6/16;
/// mỗi dòng: ô “+5” 44×32 `primary-50` bo 10 (13/700 `primary-600`), tên
/// 14/600, thời điểm 12 `text-secondary` (“Hôm nay · 20:05”,
/// “Cùng nhau · Chủ nhật”).
class _TreeHeartsHistory extends StatelessWidget {
  const _TreeHeartsHistory({required this.entries, required this.today});

  final List<HeartsEntry> entries;
  final DateTime today;

  String _day(BuildContext context, DateTime at) {
    final l10n = context.l10n;
    final days = today.dateOnly.difference(at.dateOnly).inDays;
    return switch (days) {
      0 => l10n.careTodayShort,
      1 => l10n.careYesterday,
      _ => l10n.careWeekdayLong(weekdayCode(at.weekday)),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.compact,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(context, kColorPrimary50FFF4F1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      l10n.careHeartsPlus(entry.hearts),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: kColorPrimary600C2513F,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.text14.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.together
                              ? l10n.careHistoryTogether(
                                  _day(context, entry.at),
                                )
                              : l10n.careHistoryWhen(
                                  _day(context, entry.at),
                                  entry.at.toDisplayTime(context.localeName),
                                ),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
