part of '../mobile/couple_tab_mobile_view.dart';

/// Năng lượng US-02: [max] vạch cao 12 bo 6 cách 6 — đã chọn `us-500`, còn
/// lại `us-100`. Chạm một vạch để đặt mức.
class _CheckinEnergyBar extends StatelessWidget {
  const _CheckinEnergyBar({
    required this.value,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.usEnergyValue(value),
      child: Row(
        children: [
          for (var level = 1; level <= max; level++) ...[
            if (level > 1) const SizedBox(width: AppSpacing.compact),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(level),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
                  child: Container(
                    height: AppSpacing.s3,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(
                        context,
                        level <= value ? kColorUs5009B85D1 : kColorUs100EAE2F8,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
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
