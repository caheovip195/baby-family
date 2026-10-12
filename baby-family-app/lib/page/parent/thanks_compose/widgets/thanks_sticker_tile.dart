part of '../mobile/thanks_compose_mobile_view.dart';

/// Ô sticker US-05 — cùng kiểu ô cảm xúc US-02: nền `surface-variant` bo 14,
/// đang chọn nền `us-100` viền 2 `us-500`.
class _ThanksStickerTile extends StatelessWidget {
  const _ThanksStickerTile({
    required this.sticker,
    required this.selected,
    required this.onTap,
  });

  final String sticker;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorUs100EAE2F8 : kColorSurfaceFFFFFF,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: AppColors.resolve(
              context,
              selected ? kColorUs5009B85D1 : kColorUs100EAE2F8,
            ),
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
            child: Center(
              child: Text(
                sticker,
                style: AppTypography.body.copyWith(fontSize: 24, height: 1.2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
