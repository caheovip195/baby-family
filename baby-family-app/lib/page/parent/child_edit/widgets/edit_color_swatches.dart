part of '../mobile/child_edit_mobile_view.dart';

/// Bảng 8 màu nhận diện (Pencil `cHQ4f`): ô tròn 36 dàn đều; màu đang chọn viền
/// `text-primary` 2 + `check` 16; màu bé khác đang dùng có chấm trắng 8. Gợi ý
/// 12 `text-tertiary`: “Bạc hà · Màu Đào đang dùng cho Hana”.
class _EditColorSwatches extends StatelessWidget {
  const _EditColorSwatches({required this.controller});

  final ChildEditController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = controller.child.colorIndex;
    final used = [
      for (var index = 0; index < kChildPalette.length; index++)
        if (index != selected) ?controller.siblingWithColor(index),
    ];
    final hint = [
      l10n.childColorName('$selected'),
      for (final sibling in used)
        l10n.childColorUsedBy(
          l10n.childColorName('${sibling.colorIndex}'),
          sibling.name,
        ),
    ].reduce(l10n.commonDotJoin);
    final ink = AppColors.resolve(context, kColorTextPrimary2E2A27);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var index = 0; index < kChildPalette.length; index++)
              Semantics(
                button: true,
                selected: index == selected,
                label: l10n.childColorName('$index'),
                child: GestureDetector(
                  onTap: () => controller.setColor(index),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kChildPalette[index],
                      border: index == selected
                          ? Border.all(color: ink, width: 2)
                          : null,
                    ),
                    child: index == selected
                        ? const Icon(
                            LucideIcons.check,
                            size: 16,
                            color: kColorTextPrimary2E2A27,
                          )
                        : controller.siblingWithColor(index) != null
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: kColorWhite,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Text(
          hint,
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
          ),
        ),
      ],
    );
  }
}
