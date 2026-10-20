part of '../mobile/memory_search_mobile_view.dart';

/// Lưới kết quả ảnh (`QWLZy`): 3 cột cách 4, ô 114×100; góc ngoài của khối bo
/// 12, góc trong bo 4; ô cuối có nhãn “+3” (`#2E2A2799`, 11/700 trắng).
class _SearchMediaGrid extends StatelessWidget {
  const _SearchMediaGrid({
    required this.memories,
    required this.more,
    required this.onTap,
    required this.onMore,
  });

  final List<Memory> memories;
  final int more;
  final ValueChanged<Memory> onTap;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    const columns = 3;
    final rows = (memories.length + columns - 1) ~/ columns;
    const small = Radius.circular(4);
    const big = Radius.circular(AppRadius.tile);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: memories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.s1,
        crossAxisSpacing: AppSpacing.s1,
        childAspectRatio: 114 / 100,
      ),
      itemBuilder: (_, index) {
        final row = index ~/ columns;
        final column = index % columns;
        final last = index == memories.length - 1;
        final memory = memories[index];
        final asset = memory.mediaAssets.firstOrNull;
        return GestureDetector(
          onTap: last && more > 0 ? onMore : () => onTap(memory),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: row == 0 && column == 0 ? big : small,
              topRight: row == 0 && column == columns - 1 ? big : small,
              bottomLeft: row == rows - 1 && column == 0 ? big : small,
              bottomRight: row == rows - 1 && (column == columns - 1 || last)
                  ? big
                  : small,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (asset != null)
                  Image(image: mediaImageProvider(asset), fit: BoxFit.cover)
                else
                  ColoredBox(
                    color: AppColors.resolve(
                      context,
                      kColorSurfaceVariantF7F1EC,
                    ),
                  ),
                if (last && more > 0)
                  Positioned(
                    right: AppSpacing.compact,
                    bottom: AppSpacing.compact,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: kColorSheetScrim2E2A27Alpha60,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        '+$more',
                        style: AppTypography.tiny.copyWith(
                          fontWeight: FontWeight.w700,
                          color: kColorWhite,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
