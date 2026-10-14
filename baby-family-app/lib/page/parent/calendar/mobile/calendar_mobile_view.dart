import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/care/calendar_event.dart';
import 'package:baby_family/page/parent/calendar/calendar_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/lucide_icon.dart';
import 'package:baby_family/utils/helper/lunar_date.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_extended_fab.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/app_switcher_title_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/calendar_day_cell.dart';
part '../widgets/calendar_dots.dart';
part '../widgets/calendar_event_row.dart';
part '../widgets/calendar_fab_menu.dart';
part '../widgets/calendar_legend.dart';
part '../widgets/calendar_mode_toggle.dart';
part '../widgets/calendar_month_grid.dart';
part '../widgets/calendar_month_header.dart';

/// Màu chấm theo loại (Pencil “Dots”).
Color _dotColor(CalendarDot dot) => switch (dot) {
  CalendarDot.mission => kColorPrimary500EE7B67,
  CalendarDot.event => kColorAccent500F4BF5C,
  CalendarDot.couple => kColorUs5009B85D1,
};

/// CARE-07 “Lịch” (Pencil `DRYZP`).
class CalendarMobileView extends HookConsumerWidget {
  const CalendarMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(calendarControllerProvider);
    final l10n = context.l10n;
    final day = controller.selectedDay;
    final events = controller.selectedEvents;
    final lunar = solarToLunar(day);
    final dayLunarText = l10n.commonLunarDate(lunar.day, lunar.month);
    final dayMeta = controller.isToday(day)
        ? (controller.showLunar
              ? l10n.commonDotJoin(dayLunarText, l10n.calendarToday)
              : l10n.calendarToday)
        : (controller.showLunar ? dayLunarText : null);
    final bottom = MediaQuery.paddingOf(context).bottom;

    Widget list;
    if (!controller.loaded) {
      list = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      list = Center(child: ErrorState(onRetry: controller.load));
    } else {
      list = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.cardInset,
          AppSpacing.screen,
          140 + bottom,
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.calendarDayTitle(
                        l10n.careWeekdayTitle(weekdayCode(day.weekday)),
                        day.toDayMonth(l10n.localeName),
                      ),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title20,
                      ),
                    ),
                    if (dayMeta != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        dayMeta,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small.copyWith(
                            color: kColorTextTertiary9C928A,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                l10n.calendarItemCount(events.length),
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          if (events.isEmpty)
            EmptyState(title: l10n.calendarEmptyDay, illustrationSize: 120)
          else
            for (final event in events) ...[
              _CalendarEventRow(
                event: event,
                controller: controller,
                onTap: event.missionId == null
                    ? null
                    : () => context.router.push(
                        MissionDetailRoute(missionId: event.missionId!),
                      ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
            ],
        ],
      );
    }

    return BaseScaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSwitcherTitleBar(
                  title: context.l10n.calendarTitle,
                  children: controller.children,
                  selectedId: controller.subjectId,
                  today: controller.today,
                  onChanged: controller.selectSubject,
                  onManage: () => context.router.push(const ChildrenRoute()),
                ),
                _CalendarMonthHeader(controller: controller),
                if (controller.monthMode)
                  _CalendarMonthGrid(controller: controller)
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      0,
                      AppSpacing.screen,
                      AppSpacing.s2,
                    ),
                    child: Row(
                      children: [
                        for (final (index, cell)
                            in controller.weekDays.indexed) ...[
                          if (index > 0)
                            const SizedBox(width: AppSpacing.compact),
                          Expanded(
                            child: _CalendarDayCell(
                              day: cell,
                              controller: controller,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                _CalendarLegend(controller: controller),
                Container(
                  height: 1,
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
                Expanded(child: list),
              ],
            ),
          ),
          Positioned(
            right: AppSpacing.screen,
            bottom: AppSpacing.s6 + bottom,
            child: const _CalendarFabMenu(),
          ),
        ],
      ),
    );
  }
}
