import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Tab dạng viên (Pencil CARE-01 `fkcC9`): cao 44, đệm 4, cách 4, nền
/// `surface-variant` bo 14. Ô chọn: nền `surface` bo 10 + bóng nhẹ, nhãn
/// 13/700 `text-primary`, số đếm 11/600 `primary-600`; ô khác: nhãn 13/500
/// `text-secondary`, số 11/600 `text-tertiary`.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.counts = const [],
    super.key,
  });

  final List<String> labels;

  /// Số đếm cạnh nhãn (“1/4”), cùng thứ tự [labels]; thiếu → ẩn.
  final List<String?> counts;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.all(AppSpacing.s1),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var index = 0; index < labels.length; index++) ...[
              if (index > 0) const SizedBox(width: AppSpacing.s1),
              Expanded(child: _segment(context, index)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _segment(BuildContext context, int index) {
    final selected = index == selectedIndex;
    final count = index < counts.length ? counts[index] : null;
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 36),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                : kColorTransparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: selected ? AppShadows.segment : null,
          ),
          alignment: Alignment.center,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: labels[index],
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? kColorTextPrimary2E2A27
                          : kColorTextSecondary6B625B,
                    ),
                  ),
                ),
                if (count != null)
                  TextSpan(
                    text: ' $count',
                    style: AppTypography.adapt(
                      context,
                      AppTypography.tiny.copyWith(
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? kColorPrimary600C2513F
                            : kColorTextTertiary9C928A,
                      ),
                    ),
                  ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
