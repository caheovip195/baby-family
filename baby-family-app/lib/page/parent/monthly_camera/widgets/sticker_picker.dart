part of '../mobile/monthly_camera_mobile_view.dart';

/// Dải sticker (`qTEYf`): 4 ô bằng nhau cao 38, cách 8, bo tròn, chữ 12/700.
/// Màu: sticker 1 = màu bé, 2 = `accent-500`, 3 = `primary-300`, “Không” =
/// `#FFFFFF22` chữ trắng. Ô đang chọn có viền trắng.
class _StickerPicker extends StatelessWidget {
  const _StickerPicker({required this.controller});

  final MonthlyCameraController controller;

  @override
  Widget build(BuildContext context) {
    final child = controller.child;
    final colors = [
      if (child != null) ChildAvatar.colorOf(child) else kColorChildMint9EDCC4,
      kColorAccent500F4BF5C,
      kColorPrimary300F7A796,
    ];
    final labels = [...controller.stickers, context.l10n.memStickerNone];
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectSticker(index),
              child: Container(
                constraints: const BoxConstraints(minHeight: 38),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s1,
                  vertical: AppSpacing.s1,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: index < controller.stickers.length
                      ? colors[index % colors.length]
                      : kColorWhiteAlpha13,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: index == controller.sticker
                      ? Border.all(color: kColorWhite)
                      : null,
                ),
                child: Text(
                  labels[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w700,
                    color: index < controller.stickers.length
                        ? kColorTextPrimary2E2A27
                        : kColorWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
