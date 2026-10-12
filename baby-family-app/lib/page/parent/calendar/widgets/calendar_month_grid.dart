part of '../mobile/calendar_mobile_view.dart';

/// Chế độ Tháng (mục 9.7): lưới 7 cột cùng ngôn ngữ với ô tuần — số 15/800,
/// âm lịch 10, chấm 4; ô đang chọn nền `primary-600`, hôm nay viền
/// `primary-500`. Ô ngoài tháng để trống.
class _CalendarMonthGrid extends StatelessWidget {
  const _CalendarMonthGrid({required this.controller});

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cells = controller.monthCells;
    final header = AppTypography.adapt(
      context,
      AppTypography.tiny.copyWith(color: kColorTextTertiary9C928A),
    );
    final rows = <Widget>[
      Row(
        children: [
          for (var weekday = 1; weekday <= 7; weekday++)
            Expanded(
              child: Text(
                l10n.careWeekday(weekdayCode(weekday)),
                textAlign: TextAlign.center,
                style: header,
              ),
            ),
        ],
      ),
    ];
    for (var start = 0; start < cells.length; start += 7) {
      rows
        ..add(const SizedBox(height: AppSpacing.s1))
        ..add(
          Row(
            children: [
              for (final day in cells.sublist(start, start + 7))
                Expanded(
                  child: day == null
                      ? const SizedBox.shrink()
                      : _cell(context, day),
                ),
            ],
          ),
        );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.s2,
      ),
      child: Column(children: rows),
    );
  }

  Widget _cell(BuildContext context, DateTime day) {
    final selected = controller.isSelected(day);
    final today = controller.isToday(day);
    final lunar = solarToLunar(day);
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: Material(
        color: selected
            ? AppColors.resolve(context, kColorPrimary600C2513F)
            : kColorTransparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: today && !selected
              ? BorderSide(
                  color: AppColors.resolve(context, kColorPrimary500EE7B67),
                )
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => controller.selectDay(day),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
            child: Column(
              children: [
                Text(
                  '${day.day}',
                  maxLines: 1,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.title16.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: selected ? kColorWhite : kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
                if (controller.showLunar)
                  Text(
                    lunar.day == 1
                        ? context.l10n.calendarLunarShort(
                            '${lunar.day}',
                            '${lunar.month}',
                          )
                        : '${lunar.day}',
                    maxLines: 1,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.micro.copyWith(
                        color: selected
                            ? kColorWhiteAlpha80
                            : lunar.day == 1
                            ? kColorPrimary600C2513F
                            : kColorTextTertiary9C928A,
                      ),
                    ),
                  ),
                const SizedBox(height: 2),
                _CalendarDots(dots: controller.dotsOn(day), inverted: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
