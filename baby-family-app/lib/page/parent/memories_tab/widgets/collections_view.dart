part of '../mobile/memories_tab_mobile_view.dart';

/// MEM-22 Bộ sưu tập (`xVFHt`): lưới 2 cột cách 10, đệm 16/20. Chạm:
/// Con lớn từng tháng → MEM-20, Những lần đầu → MEM-12, còn lại → chi tiết.
/// Mã thẻ “Album tự tạo” (không phải bộ sưu tập của dịch vụ).
const _albumsCode = 'albums';

class _CollectionsView extends StatelessWidget {
  const _CollectionsView({required this.controller});

  final MemoriesTabController controller;

  @override
  Widget build(BuildContext context) {
    final albums = controller.familyAlbums;
    // Doc MEM-22: “Album tự tạo (+ Album mới)” ở cuối lưới → MEM-03.
    final items = [
      ...controller.collections,
      CollectionSummary(
        code: _albumsCode,
        title: context.l10n.memAlbumsFamily,
        coverAsset: albums.firstOrNull?.coverAsset,
        count: albums.length,
      ),
    ];
    return ListView(
      padding: _listPadding(context),
      children: [
        for (var index = 0; index < items.length; index += 2) ...[
          if (index > 0) const SizedBox(height: AppSpacing.itemGap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _card(context, items[index])),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: index + 1 < items.length
                      ? _card(context, items[index + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _card(BuildContext context, CollectionSummary item) {
    final l10n = context.l10n;
    final monthly = controller.monthlyChild;
    final subjectBaby = controller.subject?.isPregnancy == false
        ? controller.subject
        : monthly;
    final subtitle = switch (item.code) {
      'monthly' => l10n.memCollMonthly(
        monthly?.name ?? '',
        controller.monthlyCount,
        controller.monthlyTotal,
      ),
      'firsts' => l10n.memCollFirsts(item.count),
      'quotes' => l10n.memCollQuotes(
        controller.quoteChild?.name ?? '',
        item.count,
      ),
      'voices' => l10n.memCollVoices(item.count),
      'letters' => l10n.memCollLetters(item.count, controller.sealedLetters),
      'best' => l10n.memCollBest(item.count),
      'keepsakes' => l10n.memCollKeepsakes(item.count),
      _albumsCode => l10n.memAlbumCount(item.count),
      _ => l10n.memoriesCount(item.count),
    };
    void open() {
      final router = context.router;
      switch (item.code) {
        case 'monthly' when monthly != null:
          router.push(MonthlyPhotosRoute(childId: monthly.id));
        case _albumsCode:
          router.push(const AlbumsRoute());
        case 'firsts' when subjectBaby != null:
          router.push(FirstsRoute(childId: subjectBaby.id));
        default:
          router.push(CollectionDetailRoute(code: item.code));
      }
    }

    return _CollectionCard(
      item: item,
      subtitle: subtitle,
      quote: controller.latestQuote?.body?.firstSentence,
      onTap: open,
    );
  }
}
