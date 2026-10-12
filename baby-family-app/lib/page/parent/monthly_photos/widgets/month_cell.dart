part of '../mobile/monthly_photos_mobile_view.dart';

/// Ô tháng (`ZNA0I`…): cao 118, bo 14. Có ảnh → ảnh phủ + nhãn “1 tháng”
/// (nền `#2E2A2799`, 11/700 trắng) góc dưới trái; tháng sắp tới → nền
/// `secondary-100`, viền `secondary-500`, camera 22 + “Tháng 6 · ngày mai”
/// 11/700; còn lại → nền `surface`, viền, “Tháng 7” 12/600 `text-tertiary`.
/// Chạm ô có ảnh → MEM-07; ô trống → MEM-21 chụp ảnh tháng đó.
class _MonthCell extends StatelessWidget {
  const _MonthCell({required this.month, required this.controller});

  final int month;
  final MonthlyPhotosController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final photo = controller.photos[month];
    final asset = photo?.asset;
    final next = month == controller.nextMonth;
    final router = context.router;
    final childId = controller.childId ?? '';
    final Widget content;
    final Color background;
    Color? border;
    if (asset != null) {
      background = kColorSurfaceVariantF7F1EC;
      content = Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(asset, fit: BoxFit.cover),
          Positioned(
            left: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s2,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: kColorSheetScrim2E2A27Alpha60,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                l10n.memoriesMonthLabel(month),
                style: AppTypography.tiny.copyWith(
                  fontWeight: FontWeight.w700,
                  color: kColorWhite,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (next) {
      background = kColorSecondary100E4F2EA;
      border = kColorSecondary5006FAE8E;
      final strong = AppColors.resolve(context, kColorSecondary7003F7A5C);
      content = Padding(
        padding: const EdgeInsets.all(AppSpacing.s1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.camera, size: 22, color: strong),
            const SizedBox(height: AppSpacing.s1),
            Text(
              l10n.memMonthlyNextIn(controller.daysToNext, month),
              textAlign: TextAlign.center,
              style: AppTypography.tiny.copyWith(
                fontWeight: FontWeight.w700,
                color: strong,
              ),
            ),
          ],
        ),
      );
    } else {
      background = kColorSurfaceFFFFFF;
      border = kColorBorderEADFD6;
      content = Center(
        child: Text(
          l10n.memMonthCell(month),
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(
              fontWeight: FontWeight.w600,
              color: kColorTextTertiary9C928A,
            ),
          ),
        ),
      );
    }
    return AspectRatio(
      aspectRatio: 111 / 118,
      child: Material(
        color: AppColors.resolve(context, background),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: border == null
              ? BorderSide.none
              : BorderSide(color: AppColors.resolve(context, border)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            final memoryId = photo?.memoryId;
            if (memoryId != null) {
              router.push(MemoryDetailRoute(memoryId: memoryId));
            } else {
              router.push(MonthlyCameraRoute(childId: childId, month: month));
            }
          },
          child: content,
        ),
      ),
    );
  }
}
