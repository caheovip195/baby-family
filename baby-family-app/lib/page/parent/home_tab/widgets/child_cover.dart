part of '../mobile/home_tab_mobile_view.dart';

/// Ảnh bìa HOME-02 (Pencil `pxO9R`): cao 230 (+ thanh trạng thái), phủ đáy
/// `#2E2A27B3`; hàng trên đệm 16: nút quay về Cả nhà 36, bộ chọn bé, nút đổi
/// ảnh bìa 36 (nền `#FFFFFF33`, icon trắng).
class _ChildCover extends StatelessWidget {
  const _ChildCover({required this.controller, required this.child});

  final HomeTabController controller;
  final Child child;

  static const height = 230.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = MediaQuery.paddingOf(context).top;
    final cover = child.coverAsset ?? child.avatarAsset;
    Widget roundButton(
      IconData icon,
      double size,
      String label,
      VoidCallback onTap,
    ) => Semantics(
      button: true,
      label: label,
      child: InkResponse(
        onTap: onTap,
        radius: AppSpacing.s6,
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: kColorWhiteAlpha20,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: size, color: kColorWhite),
        ),
      ),
    );
    return SizedBox(
      height: height + top,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (cover != null)
            Image.asset(
              cover,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 1],
                colors: [
                  kColorCoverScrim2E2A27Alpha00,
                  kColorCoverScrim2E2A27Alpha70,
                ],
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.s4,
            right: AppSpacing.s4,
            top: top + AppSpacing.s1,
            child: Row(
              children: [
                roundButton(
                  LucideIcons.chevronLeft,
                  20,
                  MaterialLocalizations.of(context).backButtonTooltip,
                  () => controller.selectSubject(null),
                ),
                Expanded(
                  child: Center(
                    child: ChildSwitcher(
                      children: controller.children,
                      today: controller.today,
                      selectedId: controller.subjectId,
                      onChanged: controller.selectSubject,
                      onManage: () =>
                          context.router.push(const ChildrenRoute()),
                    ),
                  ),
                ),
                roundButton(
                  LucideIcons.image,
                  18,
                  l10n.homeChangeCover,
                  () =>
                      context.router.push(ChildProfileRoute(childId: child.id)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
