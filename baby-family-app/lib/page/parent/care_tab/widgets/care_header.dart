part of '../mobile/care_tab_mobile_view.dart';

/// Thanh tiêu đề CARE-01 (Pencil `PkwFX`): “Chăm con” 26/800 + bộ chọn bé +
/// nút ⋯ 40 (`ellipsis` 22) → [CareMoreSheet] (CARE-08/10/12) + nút lịch 40
/// (`calendar-days` 22) → CARE-07. STATE-03 ẩn hai nút này.
class _CareHeader extends StatelessWidget {
  const _CareHeader({required this.controller, this.showCalendar = true});

  /// Bộ chọn bé giữ độ rộng tự nhiên tới mức này; tiêu đề co lại trước
  /// (màn 360 dp, chữ 130%).
  static const _switcherMaxWidth = 168.0;

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
          // Pencil `PkwFX` dàn hai đầu (space-between): không thêm khoảng
          // cách cố định sau tiêu đề để “Chăm con” đủ chỗ cạnh ⋯ và lịch.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _switcherMaxWidth),
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
                tooltip: context.l10n.careMoreMenu,
                onPressed: () => showCareMoreSheet(
                  context,
                  onHistory: () =>
                      context.router.push(const MissionHistoryRoute()),
                  onBadges: () => context.router.push(const BadgesRoute()),
                  onSettings: () =>
                      context.router.push(const MissionSettingsRoute()),
                ),
                icon: Icon(
                  LucideIcons.ellipsis,
                  size: 22,
                  color: AppColors.resolve(context, kColorTextPrimary2E2A27),
                ),
              ),
            ),
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
