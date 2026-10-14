part of '../mobile/circle_me_mobile_view.dart';

/// Cỡ chữ cho ông bà (Pencil CIR-06 “Segment”): cao 60, đệm 4, nền
/// `surface-variant` bo 16; ba ô bo 12, chữ to dần (15 · 18 · 21); ô đang
/// chọn nền `surface`, chữ 700 `primary-700`.
class _TextSizeSegment extends StatelessWidget {
  const _TextSizeSegment({required this.selected, required this.onChanged});

  final AppTextSize selected;
  final ValueChanged<AppTextSize> onChanged;

  static double _fontSize(AppTextSize size) => switch (size) {
    AppTextSize.normal => 15,
    AppTextSize.large => 18,
    AppTextSize.extraLarge => 21,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label(AppTextSize size) => switch (size) {
      AppTextSize.normal => l10n.settingsRegular,
      AppTextSize.large => l10n.settingsLarge,
      AppTextSize.extraLarge => l10n.settingsExtraLarge,
    };
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.all(AppSpacing.s1),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          for (final (index, size) in AppTextSize.values.indexed) ...[
            if (index > 0) const SizedBox(width: AppSpacing.s1),
            Expanded(
              child: Semantics(
                button: true,
                selected: size == selected,
                child: Material(
                  color: size == selected
                      ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                      : kColorTransparent,
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                    onTap: () => onChanged(size),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 52),
                      child: Center(
                        child: Text(
                          label(size),
                          textAlign: TextAlign.center,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.body.copyWith(
                              fontSize: _fontSize(size),
                              height: 1.25,
                              fontWeight: size == selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: size == selected
                                  ? kColorPrimary700A2402F
                                  : kColorTextSecondary6B625B,
                            ),
                          ),
                        ),
                      ),
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
