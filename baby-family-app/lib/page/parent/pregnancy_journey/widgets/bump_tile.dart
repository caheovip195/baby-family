part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Ô tuần của lưới bụng bầu (Pencil `CK4SD`/`wskn4`/`QYHDV`): cao 86, bo 10
/// — có ảnh + nhãn “T13”; trống (`surface`, viền `border`, “T15” 10/600
/// `text-tertiary`); tuần này chưa chụp (`us-50`, viền `us-500`, camera 16 +
/// “T24 · chụp”).
class _BumpTile extends StatelessWidget {
  const _BumpTile({
    required this.week,
    required this.isCurrent,
    required this.onCapture,
    required this.onOpen,
    this.photo,
  });

  final int week;
  final BumpPhoto? photo;
  final bool isCurrent;
  final VoidCallback onCapture;
  final ValueChanged<String> onOpen;

  static const double _height = 86;
  static const double _radius = 10;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final asset = photo?.asset;
    if (asset != null) {
      return GestureDetector(
        onTap: photo?.memoryId == null ? null : () => onOpen(photo!.memoryId!),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: SizedBox(
            height: _height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
                Positioned(
                  left: AppSpacing.s1,
                  bottom: AppSpacing.s1,
                  child: _PhotoWeekLabel(
                    text: l10n.pregWeekShort(week),
                    small: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final color = isCurrent ? kColorUs7006A549F : kColorTextTertiary9C928A;
    final label = Text(
      isCurrent ? l10n.pregWeekCapture(week) : l10n.pregWeekShort(week),
      textAlign: TextAlign.center,
      maxLines: 2,
      style: AppTypography.adapt(
        context,
        AppTypography.micro.copyWith(fontWeight: FontWeight.w600, color: color),
      ),
    );
    return Material(
      color: AppColors.resolve(
        context,
        isCurrent ? kColorUs50F6F2FC : kColorSurfaceFFFFFF,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
        side: BorderSide(
          color: AppColors.resolve(
            context,
            isCurrent ? kColorUs5009B85D1 : kColorBorderEADFD6,
          ),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(_radius),
        onTap: onCapture,
        child: SizedBox(
          height: _height,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isCurrent)
                  Icon(
                    LucideIcons.camera,
                    size: 16,
                    color: AppColors.resolve(context, color),
                  ),
                label,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
