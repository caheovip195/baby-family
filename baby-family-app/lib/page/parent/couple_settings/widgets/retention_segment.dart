part of '../mobile/couple_settings_mobile_view.dart';

/// Lựa chọn thời gian giữ Cầu nối (Pencil `Rt5a4`): cao 40, đệm 3, cách 3,
/// nền `us-50` bo 12; ô chọn nền `surface` bo 9 chữ 12/700 `us-700`; ô khác
/// 12/500 `text-secondary`.
class _RetentionSegment extends StatelessWidget {
  const _RetentionSegment({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      constraints: const BoxConstraints(minHeight: AppSpacing.s10),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorUs50F6F2FC),
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Row(
        children: [
          for (final days in CoupleSettingsController.retentionOptions) ...[
            if (days != CoupleSettingsController.retentionOptions.first)
              const SizedBox(width: 3),
            Expanded(
              child: Semantics(
                button: true,
                selected: days == selected,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(days),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 34),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: days == selected
                          ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                          : null,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      l10n.usSettingsRetention(days),
                      textAlign: TextAlign.center,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          fontWeight: days == selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: days == selected
                              ? kColorUs7006A549F
                              : kColorTextSecondary6B625B,
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
