part of '../mobile/memory_detail_mobile_view.dart';

/// Ảnh hero (`JUMYz`): cao 400, vuốt ngang khi nhiều ảnh; nút tròn 40
/// (`#2E2A2766`, icon trắng 22) back + ⋯ ở dưới thanh trạng thái; nhãn
/// “1 / 3” (`#2E2A2799`, 12/600 trắng) giữa đáy.
class _DetailHero extends StatelessWidget {
  const _DetailHero({
    required this.memory,
    required this.controller,
    required this.onMore,
  });

  final Memory memory;
  final MemoryDetailController controller;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final assets = memory.mediaAssets;
    final top = MediaQuery.paddingOf(context).top;
    Widget circle(IconData icon, String label, VoidCallback onTap) => Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: kColorOverlay2E2A27Alpha40,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 22, color: kColorWhite),
        ),
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SizedBox(
        height: assets.isEmpty ? top + 56 : 400,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (assets.isNotEmpty)
              PageView.builder(
                itemCount: assets.length,
                onPageChanged: controller.setPage,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () => context.router.push(
                    PhotoViewerRoute(memoryId: memory.id, index: index),
                  ),
                  child: Image.asset(assets[index], fit: BoxFit.cover),
                ),
              )
            else
              ColoredBox(
                color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              ),
            Positioned(
              top: top + (top > 0 ? 0 : AppSpacing.s2),
              left: AppSpacing.s4,
              right: AppSpacing.s4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  circle(
                    LucideIcons.chevronLeft,
                    context.l10n.commonBack,
                    () => context.router.maybePop(),
                  ),
                  circle(
                    LucideIcons.ellipsis,
                    context.l10n.memMoreActions,
                    onMore,
                  ),
                ],
              ),
            ),
            if (assets.length > 1)
              Positioned(
                bottom: 9,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.itemGap,
                      vertical: AppSpacing.s1,
                    ),
                    decoration: BoxDecoration(
                      color: kColorSheetScrim2E2A27Alpha60,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      '${controller.page + 1} / ${assets.length}',
                      style: AppTypography.small.copyWith(
                        fontWeight: FontWeight.w600,
                        color: kColorWhite,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
