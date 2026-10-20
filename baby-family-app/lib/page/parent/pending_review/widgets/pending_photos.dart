part of '../mobile/pending_review_mobile_view.dart';

/// Ảnh của bài chờ duyệt (Pencil “Photos” cao 180, cách 6, bo 14): 1 ảnh
/// phủ kín; 2 ảnh chia đôi; từ 3 ảnh: ảnh lớn bên trái + 2 ảnh xếp dọc.
class _PendingPhotos extends StatelessWidget {
  const _PendingPhotos({required this.assets});

  static const _height = 180.0;
  static const _gap = AppSpacing.compact;

  final List<String> assets;

  @override
  Widget build(BuildContext context) {
    Widget photo(String asset) => ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Image(
        image: mediaImageProvider(asset),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
    final Widget content;
    if (assets.length == 1) {
      content = photo(assets.first);
    } else if (assets.length == 2) {
      content = Row(
        children: [
          Expanded(child: photo(assets[0])),
          const SizedBox(width: _gap),
          Expanded(child: photo(assets[1])),
        ],
      );
    } else {
      content = Row(
        children: [
          Expanded(flex: 206, child: photo(assets[0])),
          const SizedBox(width: _gap),
          Expanded(
            flex: 110,
            child: Column(
              children: [
                Expanded(child: photo(assets[1])),
                const SizedBox(height: _gap),
                Expanded(child: photo(assets[2])),
              ],
            ),
          ),
        ],
      );
    }
    return SizedBox(height: _height, child: content);
  }
}
