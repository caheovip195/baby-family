part of '../mobile/weekly_recap_mobile_view.dart';

/// Ảnh ghép bìa (`PfPGo`): cao 250, cách 6; ô lớn trái 214 (bo 20/6/6/20),
/// cột phải 3 ô (trên bo 6/20/6/6, giữa 6, dưới 6/6/20/6).
class _RecapCollage extends StatelessWidget {
  const _RecapCollage({required this.assets});

  final List<String> assets;

  @override
  Widget build(BuildContext context) {
    const big = Radius.circular(AppRadius.xl);
    const small = Radius.circular(AppRadius.xs);
    Widget photo(String asset, BorderRadius radius) => ClipRRect(
      borderRadius: radius,
      child: Image.asset(asset, fit: BoxFit.cover),
    );
    final side = assets.skip(1).take(3).toList();
    return SizedBox(
      height: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 214,
            child: photo(
              assets.first,
              side.isEmpty
                  ? BorderRadius.circular(AppRadius.xl)
                  : const BorderRadius.only(
                      topLeft: big,
                      topRight: small,
                      bottomRight: small,
                      bottomLeft: big,
                    ),
            ),
          ),
          if (side.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.compact),
            Expanded(
              flex: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < side.length; index++) ...[
                    if (index > 0) const SizedBox(height: AppSpacing.compact),
                    Expanded(
                      child: photo(
                        side[index],
                        BorderRadius.only(
                          topLeft: small,
                          topRight: index == 0 ? big : small,
                          bottomRight: index == side.length - 1 ? big : small,
                          bottomLeft: small,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
