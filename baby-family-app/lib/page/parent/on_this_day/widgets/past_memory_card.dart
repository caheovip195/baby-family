part of '../mobile/on_this_day_mobile_view.dart';

/// Thẻ ký ức năm xưa (`a1vZ3i`): nền `surface`, viền, bo 16; 1 ảnh cao 210
/// hoặc ghép 3 ô cao 150 (ô lớn trái + 2 ô phải, cách 3, “+N” ở ô cuối);
/// thân đệm 12/14 cách 6 — chú thích 14 (1.45), meta 12 `text-tertiary` +
/// “❤️ 8  💬 3” 12 `text-secondary`.
class _PastMemoryCard extends StatelessWidget {
  const _PastMemoryCard({
    required this.memory,
    required this.meta,
    required this.onTap,
  });

  final Memory memory;
  final String meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final assets = memory.mediaAssets;
    final hearts = memory.reactions.values.fold(0, (sum, value) => sum + value);
    final stats = [
      if (hearts > 0) '❤️ $hearts',
      if (memory.commentCount > 0) '💬 ${memory.commentCount}',
    ].join('  ');
    Widget photo(String asset) =>
        Image(image: mediaImageProvider(asset), fit: BoxFit.cover);
    final Widget? media = switch (assets.length) {
      0 => null,
      1 || 2 => SizedBox(height: 210, child: photo(assets.first)),
      _ => SizedBox(
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: photo(assets[0])),
            const SizedBox(width: 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: photo(assets[1])),
                  const SizedBox(height: 3),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        photo(assets[2]),
                        if (assets.length > 3)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.itemGap,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: kColorSheetScrim2E2A27Alpha60,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                              ),
                              child: Text(
                                '+${assets.length - 3}',
                                style: AppTypography.small.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: kColorWhite,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    };
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ?media,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardInset,
                vertical: AppSpacing.s3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (memory.body != null)
                    Text(
                      memory.body!,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(height: 1.45),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.compact),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          meta,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small.copyWith(
                              color: kColorTextTertiary9C928A,
                            ),
                          ),
                        ),
                      ),
                      if (stats.isNotEmpty)
                        Text(
                          stats,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
