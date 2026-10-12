part of '../mobile/calendar_mobile_view.dart';

/// FAB “+ Sự kiện / + Nhiệm vụ” (Pencil `bYPmQ`, mục 9.7): cột căn phải cách
/// 10 — viên “Sự kiện” cao 44 nền `surface` viền `border` (icon
/// `calendar-plus` 18 `accent-700`) → CAL-02; viên “Nhiệm vụ” cao 48 nền
/// `primary-600` (icon `plus`) → CARE-03.
class _CalendarFabMenu extends StatelessWidget {
  const _CalendarFabMenu();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppExtendedFab(
          label: l10n.calendarAddEvent,
          icon: LucideIcons.calendarPlus,
          height: 44,
          color: kColorSurfaceFFFFFF,
          foreground: kColorTextPrimary2E2A27,
          iconColor: kColorAccent7009A6A12,
          bordered: true,
          onTap: () => context.router.push(const EventCreateRoute()),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        AppExtendedFab(
          label: l10n.calendarAddMission,
          icon: LucideIcons.plus,
          color: kColorPrimary600C2513F,
          onTap: () => context.router.push(MissionCreateRoute()),
        ),
      ],
    );
  }
}
