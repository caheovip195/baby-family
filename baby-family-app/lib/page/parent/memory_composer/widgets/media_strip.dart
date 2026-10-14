part of '../mobile/memory_composer_mobile_view.dart';

/// Băng ảnh (`FVqSA`): ô 96×120 bo 10 cách 8, ảnh đầu có nhãn “Bìa” (nền
/// `#2E2A27B3`, chữ trắng 11/600); ô “+” viền `border` chiếm phần còn lại.
class _MediaStrip extends StatelessWidget {
  const _MediaStrip({required this.controller, this.onAdd});

  final MemoryComposerController controller;

  /// Ô “+” thêm ảnh/video (SUB-05 khi video vượt giới hạn gói).
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final assets = controller.mediaAssets;
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 0,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: assets.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s2),
              itemBuilder: (context, index) => _photo(context, assets, index),
            ),
          ),
          if (assets.isNotEmpty) const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Semantics(
              button: true,
              label: context.l10n.memoriesAddMedia,
              excludeSemantics: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onAdd,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 38),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: AppColors.resolve(context, kColorBorderEADFD6),
                    ),
                  ),
                  child: Icon(
                    LucideIcons.plus,
                    size: 24,
                    color: AppColors.resolve(
                      context,
                      kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photo(BuildContext context, List<String> assets, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        width: 96,
        height: 120,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(assets[index], fit: BoxFit.cover),
            if (index == 0)
              Positioned(
                left: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s2,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: kColorCoverScrim2E2A27Alpha70,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    context.l10n.memoriesCover,
                    style: AppTypography.tiny.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kColorWhite,
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
