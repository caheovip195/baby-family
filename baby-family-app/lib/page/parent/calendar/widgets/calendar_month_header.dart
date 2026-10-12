part of '../mobile/calendar_mobile_view.dart';

/// Dòng tháng (Pencil `DwqCp`): `chevron-left` 18 · “Tháng 10, 2026” 18/800 ·
/// `chevron-right` 18 (cách 6) + công tắc Tuần/Tháng bên phải; đệm 0/20/10/20.
class _CalendarMonthHeader extends StatelessWidget {
  const _CalendarMonthHeader({required this.controller});

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final month = controller.monthMode
        ? controller.month
        : controller.selectedDay;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    Widget arrow(IconData icon, String tooltip, int step) => SizedBox(
      width: 28,
      height: AppSpacing.s10,
      child: IconButton(
        padding: EdgeInsets.zero,
        tooltip: tooltip,
        onPressed: () => controller.shift(step),
        icon: Icon(icon, size: 18, color: secondary),
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen - 5,
        0,
        AppSpacing.screen,
        AppSpacing.itemGap,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                arrow(LucideIcons.chevronLeft, l10n.calendarPrevMonth, -1),
                Flexible(
                  child: Text(
                    l10n.calendarMonthYear('${month.month}', '${month.year}'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                arrow(LucideIcons.chevronRight, l10n.calendarNextMonth, 1),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          _CalendarModeToggle(
            monthMode: controller.monthMode,
            onChanged: controller.setMonthMode,
          ),
        ],
      ),
    );
  }
}
