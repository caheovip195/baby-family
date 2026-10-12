part of '../mobile/calendar_mobile_view.dart';

/// Ô ngày của dải tuần (Pencil “T2 5”…): đệm dọc 8, cách 2, bo 14; thường nền
/// `surface` viền `border`, đang chọn nền `primary-600` chữ trắng. Thứ 11,
/// số 16/800, âm lịch 10 (mùng 1 hiện “1/9” 10/700 `primary-600`), chấm 5.
class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({required this.day, required this.controller});

  final DateTime day;
  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = controller.isSelected(day);
    final lunar = solarToLunar(day);
    final muted = selected ? kColorWhiteAlpha80 : kColorTextTertiary9C928A;
    final firstOfMonth = lunar.day == 1;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary600C2513F : kColorSurfaceFFFFFF,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: selected
              ? BorderSide.none
              : BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => controller.selectDay(day),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
            child: Column(
              children: [
                Text(
                  l10n.careWeekday(weekdayCode(day.weekday)),
                  maxLines: 1,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.tiny.copyWith(color: muted),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${day.day}',
                  maxLines: 1,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.title16.copyWith(
                      fontWeight: FontWeight.w800,
                      color: selected ? kColorWhite : kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
                if (controller.showLunar) ...[
                  const SizedBox(height: 2),
                  Text(
                    firstOfMonth
                        ? l10n.calendarLunarShort(
                            '${lunar.day}',
                            '${lunar.month}',
                          )
                        : '${lunar.day}',
                    maxLines: 1,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.micro.copyWith(
                        fontWeight: firstOfMonth && !selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: selected
                            ? kColorWhiteAlpha80
                            : firstOfMonth
                            ? kColorPrimary600C2513F
                            : kColorTextTertiary9C928A,
                      ),
                    ),
                  ),
                ],
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
