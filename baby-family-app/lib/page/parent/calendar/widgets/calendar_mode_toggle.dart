part of '../mobile/calendar_mobile_view.dart';

/// Công tắc Tuần / Tháng (Pencil `KmaTd`): cao 36, đệm 3, cách 2, nền
/// `surface-variant` bo 12; ô chọn nền `surface` bo 9, chữ 13/700; ô khác chữ
/// 13/500 `text-secondary`; đệm ngang 14.
class _CalendarModeToggle extends StatelessWidget {
  const _CalendarModeToggle({required this.monthMode, required this.onChanged});

  final bool monthMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      height: AppSpacing.chipHeight,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (value, label) in [
            (false, l10n.calendarModeWeek),
            (true, l10n.calendarModeMonth),
          ]) ...[
            if (value) const SizedBox(width: 2),
            Semantics(
              button: true,
              selected: value == monthMode,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(value),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.cardInset,
                  ),
                  decoration: BoxDecoration(
                    color: value == monthMode
                        ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                        : null,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    label,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        height: 16 / 13,
                        fontWeight: value == monthMode
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: value == monthMode
                            ? kColorTextPrimary2E2A27
                            : kColorTextSecondary6B625B,
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
