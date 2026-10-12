part of '../mobile/care_tab_mobile_view.dart';

/// Thanh tiêu đề CARE-01 (Pencil `PkwFX`): “Chăm con” 26/800 + bộ chọn bé +
/// nút lịch 40 (`calendar-days` 22) → CARE-07. STATE-03 ẩn nút lịch.
class _CareHeader extends StatelessWidget {
  const _CareHeader({required this.controller, this.showCalendar = true});

  final CareTabController controller;
  final bool showCalendar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s1,
        AppSpacing.screen,
        AppSpacing.s2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.careTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.adapt(context, AppTypography.h1),
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          Flexible(
            child: ChildSwitcher(
              children: controller.children,
              selectedId: controller.subjectId,
              today: controller.today,
              onChanged: controller.selectSubject,
              onManage: () => context.router.push(const ChildrenRoute()),
            ),
          ),
          if (showCalendar) ...[
            const SizedBox(width: AppSpacing.s2),
            SizedBox.square(
              dimension: AppSpacing.s10,
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: context.l10n.calendarTitle,
                onPressed: () => context.router.push(const CalendarRoute()),
                icon: Icon(
                  LucideIcons.calendarDays,
                  size: 22,
                  color: AppColors.resolve(context, kColorTextPrimary2E2A27),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
