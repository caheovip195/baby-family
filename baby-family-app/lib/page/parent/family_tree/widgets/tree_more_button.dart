part of '../mobile/family_tree_mobile_view.dart';

/// Nút ⋯ trên thanh CARE-09 (thiết kế không vẽ lối vào — mục 9.7 cần link
/// Huy hiệu; gom thêm Lịch sử & Cài đặt nhiệm vụ): mở sheet 3 dòng →
/// CARE-10 / CARE-08 / CARE-12.
class _TreeMoreButton extends StatelessWidget {
  const _TreeMoreButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return IconButton(
      tooltip: l10n.careMoreMenu,
      onPressed: () => showAppBottomSheet<void>(
        context,
        builder: (sheetContext) {
          void open(PageRouteInfo route) {
            Navigator.of(sheetContext).pop();
            context.router.push(route);
          }

          return AppBottomSheet(
            gap: 0,
            children: [
              AppSettingRow(
                icon: LucideIcons.award,
                title: l10n.careBadgesTitle,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.cardInset,
                ),
                divider: true,
                onTap: () => open(const BadgesRoute()),
              ),
              AppSettingRow(
                icon: LucideIcons.history,
                title: l10n.careMenuHistory,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.cardInset,
                ),
                divider: true,
                onTap: () => open(const MissionHistoryRoute()),
              ),
              AppSettingRow(
                icon: LucideIcons.settings,
                title: l10n.careSettingsTitle,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.cardInset,
                ),
                onTap: () => open(const MissionSettingsRoute()),
              ),
            ],
          );
        },
      ),
      icon: Icon(
        LucideIcons.ellipsis,
        size: 24,
        color: AppColors.resolve(context, kColorTextPrimary2E2A27),
      ),
    );
  }
}
