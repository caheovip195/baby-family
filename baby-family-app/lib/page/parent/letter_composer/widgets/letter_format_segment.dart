part of '../mobile/letter_composer_mobile_view.dart';

/// “Hình thức” (`ADTzD`): cao 44, đệm 4, cách 4, nền `surface-variant` bo
/// 14. Ô chọn: nền `surface` bo 10 + bóng nhẹ, icon 16 `primary-600` + chữ
/// 13/700; ô khác: icon `text-secondary` + chữ 13/500 `text-secondary`.
class _LetterFormatSegment extends StatelessWidget {
  const _LetterFormatSegment({required this.selected, required this.onChanged});

  final LetterFormat selected;
  final ValueChanged<LetterFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (LetterFormat.write, LucideIcons.penLine, l10n.memLetterWrite),
      (LetterFormat.voice, LucideIcons.mic, l10n.memFilterVoice),
      (LetterFormat.video, LucideIcons.video, l10n.memLetterVideo),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s1),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          for (final (value, icon, label) in items) ...[
            if (value != items.first.$1) const SizedBox(width: AppSpacing.s1),
            Expanded(
              child: Semantics(
                button: true,
                selected: value == selected,
                child: GestureDetector(
                  onTap: () => onChanged(value),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s1,
                    ),
                    decoration: value == selected
                        ? BoxDecoration(
                            color: AppColors.resolve(
                              context,
                              kColorSurfaceFFFFFF,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            boxShadow: AppShadows.segment,
                          )
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: AppColors.resolve(
                            context,
                            value == selected
                                ? kColorPrimary600C2513F
                                : kColorTextSecondary6B625B,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.compact),
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.caption.copyWith(
                                fontWeight: value == selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                height: 16 / 13,
                                color: value == selected
                                    ? kColorTextPrimary2E2A27
                                    : kColorTextSecondary6B625B,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
