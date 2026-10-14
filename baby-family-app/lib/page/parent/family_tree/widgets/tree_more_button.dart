part of '../mobile/family_tree_mobile_view.dart';

/// Nút ⋯ trên thanh CARE-09 (mục 9.7 cần link Huy hiệu; gom thêm Lịch sử &
/// Cài đặt nhiệm vụ, Thống kê): mở [CareMoreSheet] → CARE-08/10/11/12.
class _TreeMoreButton extends StatelessWidget {
  const _TreeMoreButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return IconButton(
      tooltip: l10n.careMoreMenu,
      onPressed: () => showCareMoreSheet(
        context,
        onHistory: () => context.router.push(const MissionHistoryRoute()),
        onStats: () => context.router.push(const CareStatsRoute()),
        onBadges: () => context.router.push(const BadgesRoute()),
        onSettings: () => context.router.push(const MissionSettingsRoute()),
      ),
      icon: Icon(
        LucideIcons.ellipsis,
        size: 24,
        color: AppColors.resolve(context, kColorTextPrimary2E2A27),
      ),
    );
  }
}
