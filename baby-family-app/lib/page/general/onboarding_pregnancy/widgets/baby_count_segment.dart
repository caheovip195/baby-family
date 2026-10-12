part of '../mobile/onboarding_pregnancy_mobile_view.dart';

/// Segmented “Số bé”: cao 44, đệm 4, cách 4, nền `surface-variant` bo tròn;
/// mục chọn nền `surface` chữ 14/600 `text-primary`, còn lại 14/500
/// `text-secondary`.
class _BabyCountSegment extends StatelessWidget {
  const _BabyCountSegment({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 44),
    padding: const EdgeInsets.all(AppSpacing.s1),
    decoration: BoxDecoration(
      color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.s1),
          Expanded(
            child: Semantics(
              button: true,
              selected: index == selectedIndex,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(index),
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: AppSpacing.chipHeight,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: index == selectedIndex
                        ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                        : kColorTransparent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    labels[index],
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: index == selectedIndex
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: index == selectedIndex
                            ? kColorTextPrimary2E2A27
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
