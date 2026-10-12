part of '../mobile/mission_history_mobile_view.dart';

/// Nhóm một ngày (Pencil “Hôm nay · Thứ Tư 07/10”): đầu dòng 14/700 + ngày âm
/// 12 `text-tertiary` bên phải, cách 8; thẻ `surface` viền `border` bo 16.
class _HistoryDayGroup extends StatelessWidget {
  const _HistoryDayGroup({required this.day, required this.controller});

  final MissionHistoryDay day;
  final MissionHistoryController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = l10n.careHistoryDate(
      l10n.careWeekdayTitle(weekdayCode(day.date.weekday)),
      day.date.toDayMonth(l10n.localeName),
    );
    final today = controller.today;
    final title = day.date.isSameDay(today)
        ? l10n.careHistoryToday(date)
        : day.date.isSameDay(today.subtract(const Duration(days: 1)))
        ? l10n.careHistoryYesterday(date)
        : date;
    final lunar = solarToLunar(day.date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Text(
              l10n.careHistoryLunar('${lunar.day}', '${lunar.month}'),
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s2),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final (index, entry) in day.entries.indexed)
                _HistoryEntryRow(
                  entry: entry,
                  controller: controller,
                  divider: index < day.entries.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
