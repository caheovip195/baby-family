part of '../mobile/home_tab_mobile_view.dart';

/// App bar HOME-01/03 (Pencil `B9BCrF`): đệm 4/20/8/20; avatar gia đình 40
/// (nền chuyển `primary-100` → `accent-100`, icon `house-heart` 20), bộ chọn
/// bé ở giữa, chuông 24 + chấm `primary-500` 9 khi có thông báo chưa đọc.
/// Giữ avatar gia đình → FAM-08 “Chuyển gia đình”.
class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({required this.controller});

  final HomeTabController controller;

  Future<void> _switchFamily(BuildContext context) async {
    final memberships = await controller.memberships();
    if (!context.mounted || memberships.length < 2) {
      return;
    }
    final familyId = await showSwitchFamilySheet(
      context,
      memberships: memberships,
    );
    final picked = memberships.where((m) => m.familyId == familyId).firstOrNull;
    if (picked == null || picked.current || !context.mounted) {
      return;
    }
    final session = await controller.switchFamily(picked.familyId);
    if (kValueUseRemoteSession && context.mounted) {
      await context.router.replaceAll([routeForSession(session)]);
      return;
    }
    if (context.mounted) {
      final current = memberships.where((m) => m.current).firstOrNull;
      showAppSnackBar(
        context,
        context.l10n.famSwitchMock(current?.familyName ?? ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s1,
        AppSpacing.screen,
        AppSpacing.s2,
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: l10n.homeOpenFamily,
            child: GestureDetector(
              onTap: () => context.router.push(const FamilyRoute()),
              // FAM-08: giữ avatar gia đình để chuyển gia đình (khi tài khoản
              // thuộc nhiều gia đình).
              onLongPress: () => _switchFamily(context),
              child: Container(
                width: AppSpacing.s10,
                height: AppSpacing.s10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // Pencil: gradient 200° #FFE3DC → #FDF1D6 (giữ nguyên ở dark).
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [kColorPrimary100FFE3DC, kColorAccent100FDF1D6],
                  ),
                ),
                child: const Icon(
                  LucideIcons.houseHeart,
                  size: 20,
                  color: kColorPrimary600C2513F,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ChildSwitcher(
                children: controller.children,
                today: controller.today,
                selectedId: controller.subjectId,
                onChanged: controller.selectSubject,
                onManage: () => context.router.push(const ChildrenRoute()),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: l10n.commonNotifications,
            child: InkResponse(
              onTap: () => context.router.push(const NotificationsRoute()),
              radius: AppSpacing.s6,
              child: SizedBox.square(
                dimension: AppSpacing.s10,
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        LucideIcons.bell,
                        size: 24,
                        color: AppColors.resolve(
                          context,
                          kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                    if (controller.unreadCount > 0)
                      Positioned(
                        left: 24,
                        top: AppSpacing.s2,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.resolve(
                              context,
                              kColorPrimary500EE7B67,
                            ),
                            border: Border.all(
                              color: AppColors.resolve(context, kColorBgFFFBF7),
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
