part of '../mobile/event_create_mobile_view.dart';

/// Thẻ ngày (Pencil `BN1UW`): Dùng ngày Âm lịch · ngày (âm/dương) · Lặp lại
/// hằng năm · Cả ngày · Giờ; dòng đệm 12/14, kẻ `border` giữa các dòng.
class _EventDateCard extends StatelessWidget {
  const _EventDateCard({required this.controller});

  final EventCreateController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final event = controller.event;
    final lunar = controller.lunarDate;
    final solar = l10n.calendarDayTitle(
      l10n.careWeekdayTitle(weekdayCode(event.date.weekday)),
      event.date.toFormDate(l10n.localeName),
    );
    final chevron = Icon(
      LucideIcons.chevronRight,
      size: 18,
      color: AppColors.resolve(context, kColorTextTertiary9C928A),
    );
    const padding = EdgeInsets.symmetric(
      horizontal: AppSpacing.cardInset,
      vertical: AppSpacing.s3,
    );

    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: event.date,
        firstDate: DateTime(controller.today.year - 1),
        lastDate: DateTime(controller.today.year + 5),
      );
      if (picked != null) {
        controller.setDate(picked);
      }
    }

    Future<void> pickTime() async {
      final parts = (event.time ?? '').split(':');
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: int.tryParse(parts.first) ?? 9,
          minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
        ),
      );
      if (picked != null) {
        controller.setTime(
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}',
        );
      }
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AppSettingRow(
            icon: LucideIcons.moonStar,
            title: l10n.calendarUseLunar,
            padding: padding,
            divider: true,
            onTap: () => controller.setLunar(!event.lunar),
            trailing: AppSwitch(
              value: event.lunar,
              onChanged: controller.setLunar,
            ),
          ),
          AppSettingRow(
            icon: LucideIcons.calendarDays,
            title: event.lunar
                ? l10n.calendarLunarDayName('${lunar.day}', '${lunar.month}')
                : solar,
            subtitle: event.lunar ? l10n.calendarThisYear(solar) : null,
            padding: padding,
            divider: true,
            onTap: pickDate,
            trailing: chevron,
          ),
          AppSettingRow(
            icon: LucideIcons.repeat,
            title: l10n.calendarRepeatYearly,
            subtitle: event.lunar
                ? l10n.calendarRepeatByLunar
                : l10n.calendarRepeatBySolar,
            padding: padding,
            divider: true,
            onTap: () => controller.setRepeatYearly(!event.repeatYearly),
            trailing: AppSwitch(
              value: event.repeatYearly,
              onChanged: controller.setRepeatYearly,
            ),
          ),
          AppSettingRow(
            icon: LucideIcons.sun,
            title: l10n.calendarAllDay,
            padding: padding,
            divider: !event.allDay,
            onTap: () => controller.setAllDay(!event.allDay),
            trailing: AppSwitch(
              value: event.allDay,
              onChanged: controller.setAllDay,
            ),
          ),
          if (!event.allDay)
            AppSettingRow(
              icon: LucideIcons.alarmClock,
              title: l10n.calendarTime,
              subtitle: event.time,
              padding: padding,
              onTap: pickTime,
              trailing: chevron,
            ),
        ],
      ),
    );
  }
}
