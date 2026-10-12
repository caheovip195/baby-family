part of '../mobile/memories_tab_mobile_view.dart';

/// App bar MEM-01 (`A0Ehte`): cao 52, đệm ngang 20; “Ký ức” 26/800; bên
/// phải ChildSwitcher + nút tìm kiếm 40 (nền `surface`, viền, bo 12).
class _MemoriesAppBar extends StatelessWidget {
  const _MemoriesAppBar({required this.controller});

  final MemoriesTabController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.memoriesTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.adapt(context, AppTypography.h1),
              ),
            ),
            if (controller.children.isNotEmpty)
              Flexible(
                child: ChildSwitcher(
                  children: controller.children,
                  selectedId: controller.subjectId,
                  today: controller.today,
                  onChanged: controller.selectSubject,
                ),
              ),
            const SizedBox(width: AppSpacing.itemGap),
            Semantics(
              button: true,
              label: context.l10n.memSearch,
              excludeSemantics: true,
              child: GestureDetector(
                onTap: () => context.router.push(const MemorySearchRoute()),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                    border: Border.all(
                      color: AppColors.resolve(context, kColorBorderEADFD6),
                    ),
                  ),
                  child: Icon(
                    LucideIcons.search,
                    size: 18,
                    color: AppColors.resolve(
                      context,
                      kColorTextSecondary6B625B,
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
