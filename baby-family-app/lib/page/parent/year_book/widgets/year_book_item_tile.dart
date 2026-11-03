part of '../mobile/year_book_mobile_view.dart';

/// Một ký ức trong chương: ô chọn + ngày + chú thích (chạm để sửa), hàng ảnh
/// chạm để chọn/bỏ.
class _YearBookItemTile extends StatelessWidget {
  const _YearBookItemTile({
    required this.controller,
    required this.month,
    required this.item,
  });

  final YearBookController controller;
  final int month;
  final YearBookItem item;

  static const _thumb = 76.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Người thân: chỉ ảnh đã chọn, không chạm để sửa.
    final readOnly = controller.readOnly;
    final photos = readOnly
        ? [
            for (final photo in item.photos)
              if (item.selectedAssetIds.contains(photo.assetId)) photo,
          ]
        : item.photos;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    final date = DateTime.tryParse(item.occurredAt ?? '')?.toLocal();
    Future<void> editCaption() async {
      final value = await showAppTextInputSheet(
        context,
        title: l10n.yearBookCaption,
        actionLabel: l10n.commonSave,
        initialValue: item.caption,
      );
      if (value != null) {
        controller.setCaption(month, item.memoryId, value);
      }
    }

    return Opacity(
      opacity: item.included ? 1 : 0.55,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s2,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!readOnly)
                  GestureDetector(
                    key: ValueKey('yearbook-item-${item.memoryId}'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => controller.toggleItem(month, item.memoryId),
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.s3),
                      child: AppCheckMark(checked: item.included),
                    ),
                  ),
                Expanded(
                  child: InkWell(
                    onTap: readOnly ? null : editCaption,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (date != null)
                          Text(
                            date.toFormDate(l10n.localeName),
                            style: AppTypography.adapt(
                              context,
                              AppTypography.caption.copyWith(color: secondary),
                            ),
                          ),
                        Text(
                          item.caption.isEmpty
                              ? l10n.yearBookCaption
                              : item.caption,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.text14.copyWith(
                              color: item.caption.isEmpty ? secondary : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (photos.isNotEmpty)
              SizedBox(
                height: _thumb,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.s2),
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return _PhotoToggle(
                      key: ValueKey('yearbook-photo-${photo.assetId}'),
                      photo: photo,
                      size: _thumb,
                      selected:
                          !readOnly &&
                          item.selectedAssetIds.contains(photo.assetId),
                      onTap: readOnly
                          ? null
                          : () => controller.togglePhoto(
                              month,
                              item.memoryId,
                              photo.assetId,
                            ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PhotoToggle extends StatelessWidget {
  const _PhotoToggle({
    required this.photo,
    required this.size,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final YearBookPhoto photo;
  final double size;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: AppColors.resolve(context, kColorBorderEADFD6),
      alignment: Alignment.center,
      child: Icon(
        LucideIcons.image,
        size: 20,
        color: AppColors.resolve(context, kColorTextTertiary9C928A),
      ),
    );
    final url = photo.url;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: url == null
                  ? placeholder
                  : Image.network(
                      url,
                      fit: BoxFit.cover,
                      cacheWidth: (size * 3).round(),
                      errorBuilder: (_, _, _) => placeholder,
                    ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: AppCheckMark(checked: selected, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
